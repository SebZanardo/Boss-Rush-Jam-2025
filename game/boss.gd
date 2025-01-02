extends CharacterBody2D

enum States {IDLE, WALK, FIRING, DASH_PREPARATION, DASH, DASH_STOP, HURT, DEATH}
var state: States = States.IDLE

@onready var animator = $AnimatedSprite2D
@onready var timer = $Timer

@export var max_health: int = 100
var health: int = max_health

@export var speed: int = 60

var target_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_state(States.IDLE)


func _physics_process(_delta: float) -> void:
	match state:
		States.IDLE:
			if timer.time_left <= 0:
				# TODO: Transition to WALK STATE if player is far away
				# TODO: Transition to FIRE STATE if player is medium range
				# TODO: Transition to DASH STATE if player is close
				set_state(States.WALK)
				print("walk")
		States.WALK:
			if target_position == Vector2.ZERO or position.distance_to(target_position) <= 5:
				# Generate random target position inside of viewport to move to
				var tx = randi_range(0, get_viewport_rect().size.x)
				var ty = randi_range(0, get_viewport_rect().size.y)
				target_position = Vector2(tx, ty)
				velocity = position.direction_to(target_position) * speed
				print("NEW POS", target_position)
			move_and_slide()
		States.FIRING:
			pass
		States.DASH_PREPARATION:
			pass
		States.DASH:
			pass
		States.DASH_STOP:
			pass
		States.HURT:
			pass
		States.DEATH:
			pass


func set_state(new_state: States) -> void:
	# TODO: Perform specific logic to switch between states
	match new_state:
		States.IDLE:
			timer.wait_time = 3
			timer.start()
			animator.play("idle")
		States.WALK:
			animator.play("walk")
		States.FIRING:
			pass
		States.DASH_PREPARATION:
			animator.play("dash preparation")
		States.DASH:
			animator.play("dash")
		States.DASH_STOP:
			animator.play("dash stop")
		States.HURT:
			animator.play("hurt")
		States.DEATH:
			animator.play("death")
	state = new_state


# TODO: Change state to hurt if not invincible
func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
	pass
