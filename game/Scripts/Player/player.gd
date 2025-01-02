extends CharacterBody2D

var max_speed : float = 200
var acceleration : float = 3000

var axis : Vector2

@export var cam_gradient : float = 1000
@export var max_cam_offset : float = 64

@onready var camera = $player_cam

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(acceleration):
	velocity += acceleration
	velocity = velocity.limit_length(max_speed)

func get_dir():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func _physics_process(delta: float) -> void:
	var dir = get_dir()
	if dir == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		apply_movement(dir * acceleration * delta)
	
	#$animations.look_at(get_global_mouse_position())
	
	move_and_slide()

func _process(delta: float) -> void:
	var mouseoffset = (get_viewport().get_mouse_position() - get_viewport_rect().size / 2)
	camera.position = lerp(Vector2.ZERO, mouseoffset.normalized() * max_cam_offset, mouseoffset.length() / cam_gradient)
