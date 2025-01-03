extends CharacterBody2D


@export var max_speed : float = 150
@export var acceleration : float = 2500

@export var cam_gradient : float = 1000
@export var max_cam_offset : float = 64

@onready var camera = $player_cam
@onready var animator = $AnimatedSprite2D


# NOTE: Temporary for testing projectile system
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var mouse_offset = (get_viewport().get_mouse_position() - get_viewport_rect().size / 2)
		var direction = global_position.direction_to(global_position + mouse_offset)
		projectile_manager.spawn_projectile(projectile_manager.ProjectileType.BASIC, position, direction)


func _physics_process(delta: float) -> void:
	var dir = get_move_direction()
	if dir == Vector2.ZERO:
		apply_friction(acceleration * delta)
		animator.play("idle")
	else:
		apply_movement(dir * acceleration * delta)
		animator.play("run")

	move_and_slide()


func _process(_delta: float) -> void:
	# Flip player sprite based on move direction
	if velocity.x > 0:
		animator.flip_h = false
	elif velocity.x < 0:
		animator.flip_h = true
	# If player is still flip based on mouse
	else:
		animator.flip_h = true if get_global_mouse_position().x < global_position.x else false
	
	# Move camera
	var mouse_offset = (get_viewport().get_mouse_position() - get_viewport_rect().size / 2)
	camera.position = lerp(Vector2.ZERO, mouse_offset.normalized() * max_cam_offset, mouse_offset.length() / cam_gradient)


func apply_friction(amount: float) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func apply_movement(acc: Vector2) -> void:
	velocity += acc
	velocity = velocity.limit_length(max_speed)


func get_move_direction() -> Vector2:
	var axis : Vector2
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()
