class_name Map extends Node2D

@export_group("Settings")
@export var identifier: String = ""
@export var tile_size: int = 64
@export_group("Nodes")
@export var layers: Array[TileMapLayer]
@export var spawn_location: Node2D
@export_group("Objects")
@export var entities: Array[PackedScene]


# Define a área total válida do mapa combinando todas as camadas dos layers
var map_bounds = Rect2i()

# Array 2D para armazenar tiles ocupados
var ocuped_tiles: Array = []
# Array 2D para armazenar tiles bloqueados (true = bloqueado, false = livre)
var blocked_tiles: Array = []
# Array 2D para armazenar tiles bloqueados (Direcao)
var blocked_direction_tiles: Array = []


func _ready() -> void:
	# Se não houver layer no array, não acontece nada
	if layers.is_empty():
		return

	var combined_rect = _calculate_combined_rect()
	map_bounds = _get_map_bounds(combined_rect)

	_initialize_tile_arrays()
	_populate_blocked_tiles()

	for scene in entities:
		if scene and scene is PackedScene:
			var instance = scene.instantiate()
			if instance is Entity:
				add_entity(instance, instance.map_position)


func _calculate_combined_rect() -> Rect2i:
	# Define um retângulo inicial vazio que será expandido conforme necessário
	var combined_rect = Rect2i()

	for layer in layers:
		var rect = layer.get_used_rect()

		# Se o TileMapLayer tem tiles usados, expande o retângulo combinado para incluir essa área
		if rect.has_area():
			combined_rect = combined_rect.merge(rect)

	# Garante que o mapa tenha pelo menos um ponto inicial e final válidos
	if not combined_rect.has_area():
		combined_rect = Rect2i(Vector2i.ZERO, Vector2i.ONE)

	return combined_rect


func _get_map_bounds(combined_rect: Rect2i) -> Rect2i:
	# Calcula o tamanho final do mapa combinando todas as camadas
	var tilemap_size = combined_rect.end - combined_rect.position
	return Rect2i(combined_rect.position, tilemap_size)


func _initialize_tile_arrays() -> void:
	var width = map_bounds.size.x
	var height = map_bounds.size.y

	ocuped_tiles.resize(width)
	blocked_tiles.resize(width)
	blocked_direction_tiles.resize(width)

	for x in width:
		ocuped_tiles[x] = []
		blocked_tiles[x] = []
		blocked_direction_tiles[x] = []

		ocuped_tiles[x].resize(height)
		blocked_tiles[x].resize(height)
		blocked_direction_tiles[x].resize(height)


func _populate_blocked_tiles() -> void:
	for x in map_bounds.size.x:
		for y in map_bounds.size.y:
			var coordinates = map_bounds.position + Vector2i(x, y)
			var block = false
			var blocked_directions = Vector2i.ZERO

			for layer in layers:
				var tile_data = layer.get_cell_tile_data(coordinates)
				if tile_data:
					block = block or tile_data.get_custom_data("block") as bool

					var custom_dir = tile_data.get_custom_data("block_direction")
					if custom_dir:
						blocked_directions = custom_dir

			blocked_tiles[x][y] = block
			blocked_direction_tiles[x][y] = blocked_directions


func world_to_grid(world_pos: Vector2) -> Vector2i:
	var grid_pos = world_pos / tile_size
	return Vector2i(grid_pos.x, grid_pos.y)


func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos.x * tile_size, grid_pos.y * tile_size)


func is_cell_occupied(grid_pos: Vector2i) -> bool:
	var adjusted_x = grid_pos.x - map_bounds.position.x
	var adjusted_y = grid_pos.y - map_bounds.position.y

	if adjusted_x >= 0 and adjusted_x < map_bounds.size.x and adjusted_y >= 0 and adjusted_y < map_bounds.size.y:
		return ocuped_tiles[adjusted_x][adjusted_y] != null

	return false


func add_entity(entity: Entity, grid_pos: Vector2i) -> void:
	# Ajusta as coordenadas para o array 2D
	var adjusted_x = grid_pos.x - map_bounds.position.x
	var adjusted_y = grid_pos.y - map_bounds.position.y

	# Verifica se está dentro dos limites
	if adjusted_x >= 0 and adjusted_x < map_bounds.size.x and adjusted_y >= 0 and adjusted_y < map_bounds.size.y:
		ocuped_tiles[adjusted_x][adjusted_y] = entity

	# Atualiza a posição da entidade no mundo
	entity.map_position = grid_pos
	entity.position = grid_to_world(grid_pos)
	entity.current_map = self

	# Spawna a entidade no spawn location
	spawn_location.add_child(entity)


func is_cell_blocked(grid_pos: Vector2i) -> bool:
	var adjusted_x = grid_pos.x - map_bounds.position.x
	var adjusted_y = grid_pos.y - map_bounds.position.y

	if adjusted_x >= 0 and adjusted_x < map_bounds.size.x and adjusted_y >= 0 and adjusted_y < map_bounds.size.y:
		return blocked_tiles[adjusted_x][adjusted_y]
	return true


func _check_direction_block(block_dir: Vector2i, direction: Vector2i) -> bool:
	return (
		(direction == Vector2i.LEFT and block_dir.x < 0) or
		(direction == Vector2i.RIGHT and block_dir.x > 0) or
		(direction == Vector2i.UP and block_dir.y < 0) or
		(direction == Vector2i.DOWN and block_dir.y > 0)
	)


func _is_direction_blocked(grid_pos: Vector2i, direction: Vector2i) -> bool:
	var adjusted_x = grid_pos.x - map_bounds.position.x
	var adjusted_y = grid_pos.y - map_bounds.position.y

	# Retorna falso se está fora dos limites
	if not _is_within_bounds(adjusted_x, adjusted_y):
		return false

	# Retorna verdadeiro se o movimento é bloqueado na origem
	var block_dir_from = blocked_direction_tiles[adjusted_x][adjusted_y]
	if _check_direction_block(block_dir_from, direction):
		return true

	# Verifica a célula de destino
	var adjusted_x_to = adjusted_x + direction.x
	var adjusted_y_to = adjusted_y + direction.y

	# Verifica se as coordenadas fornecidas estão dentro dos limites do mapa
	if _is_within_bounds(adjusted_x_to, adjusted_y_to):
		var block_dir_to = blocked_direction_tiles[adjusted_x_to][adjusted_y_to]
		if _check_direction_block(block_dir_to, -direction):
			return true

	return false


func _is_within_bounds(x: int, y: int) -> bool:
	return x >= 0 and x < map_bounds.size.x and y >= 0 and y < map_bounds.size.y


func move_entity(entity: Entity, direction: Vector2i) -> Vector2:
	var old_grid_pos = entity.map_position
	var new_grid_pos = old_grid_pos + direction

	# Verifica se a nova célula está bloqueada ou ocupada por outra entidade
	if is_cell_blocked(new_grid_pos) or (is_cell_occupied(new_grid_pos) and new_grid_pos != old_grid_pos):
		return entity.position

	# Verifica se o movimento na direção especificada é bloqueado
	if _is_direction_blocked(old_grid_pos, direction):
		return entity.position

	# Atualiza o grid de ocupação se o movimento é válido
	if old_grid_pos != new_grid_pos:
		var old_x = old_grid_pos.x - map_bounds.position.x
		var old_y = old_grid_pos.y - map_bounds.position.y
		var new_x = new_grid_pos.x - map_bounds.position.x
		var new_y = new_grid_pos.y - map_bounds.position.y

		if (old_x >= 0 and old_x < map_bounds.size.x and old_y >= 0 and old_y < map_bounds.size.y and
			new_x >= 0 and new_x < map_bounds.size.x and new_y >= 0 and new_y < map_bounds.size.y):
			# Libera a célula antiga
			ocuped_tiles[old_x][old_y] = null
			# Marca a nova célula como ocupada
			ocuped_tiles[new_x][new_y] = entity
		else:
			return entity.position

	# Altera a grid da entidade para a nova
	entity.map_position = new_grid_pos
	return grid_to_world(new_grid_pos)
