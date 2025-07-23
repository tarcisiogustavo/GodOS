class_name Actor
extends Entity


func attack() -> void:
	if is_animation_locked:
		return

	play_attack_animation()


func play_attack_animation() -> void:
	if is_animation_locked:
		return

	if is_moving:
		_stop_movement()

	if current_direction != Vector2.ZERO:
		previous_direction = current_direction

	current_animation = AnimationState.ATTACKING
	is_animation_locked = true

	var attack_animation = _get_animation_name(AnimationState.ATTACKING)
	if animation and animation.has_animation(attack_animation):
		animation.play(attack_animation)


func _on_attack_finished() -> void:
	is_animation_locked = false

	if is_moving:
		current_animation = AnimationState.WALKING
	else:
		current_animation = AnimationState.STOPPED

	update_animation()


func _get_animation_name(state: AnimationState) -> String:
	if state == AnimationState.ATTACKING:
		return "attack_" + _get_direction_suffix()

	return super._get_animation_name(state)
