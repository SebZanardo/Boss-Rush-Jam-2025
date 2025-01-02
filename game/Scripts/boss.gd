extends CharacterBody2D

enum States {IDLE, WALK, FIRING, DASH_PREPARATION, DASH, DASH_STOP, HURT, DEATH}
var state: States = States.IDLE

@onready var animator = $AnimatedSprite2D
@onready var timer = $Timer

# TODO: Change this to be the player
@onready var target: Vector2 = get_viewport().get_mouse_position()

@export var max_health: int = 100
var health: int = max_health

@export var walk_speed: int = 60
@export var dash_speed: int = 200


var target_move_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_state(States.IDLE)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("try hurt")
		try_hurt(10)


func _physics_process(_delta: float) -> void:
	target = get_viewport().get_mouse_position()
	
	# Flip sprite
	if velocity.x > 0:
		animator.flip_h = false
	if velocity.x < 0:
		animator.flip_h = true

	match state:
		States.IDLE:
			if timer.time_left <= 0:
				decide_next_attack()
				
		States.WALK:
			# If within threshold to target_move_position
			if position.distance_to(target_move_position) <= 5:
				set_state(States.IDLE)
			move_and_slide()
			
		States.FIRING:
			if timer.time_left <= 0:
				set_state(States.IDLE)
				
		States.DASH_PREPARATION:
			if timer.time_left <= 0:
				set_state(States.DASH)
			
		States.DASH:
			if position.distance_to(target_move_position) <= 5:
				set_state(States.DASH_STOP)
			move_and_slide()
		
		States.DASH_STOP:
			if timer.time_left <= 0:
				set_state(States.IDLE)
			
		States.HURT:
			if timer.time_left <= 0:
				if health <= 0:
					set_state(States.DEATH)
				else:
					set_state(States.IDLE)
			
		States.DEATH:
			# TODO: DESTROY!!!
			pass


func set_state(new_state: States) -> void:
	# Perform specific logic to switch between states
	match new_state:
		States.IDLE:
			velocity = Vector2.ZERO
			timer.wait_time = randi_range(1, 3)
			timer.start()
			
			animator.play("idle")
			
		States.WALK:
			# Generate random target position near target
			var tx = randi_range(target.x - 100, target.x + 100)
			var ty = randi_range(target.y - 100, target.y + 100)
			target_move_position = Vector2(tx, ty)
			velocity = position.direction_to(target_move_position) * walk_speed
			
			animator.play("walk")
			
		States.FIRING:
			velocity = Vector2.ZERO
			timer.wait_time = 5
			timer.start()
			
			animator.play("firing")
			
		States.DASH_PREPARATION:
			velocity = Vector2.ZERO
			timer.wait_time = 0.5
			timer.start()
			
			animator.play("dash preparation")
		
		States.DASH:
			# TODO: Predict future position based on player velocity
			var tx = randi_range(target.x - 10, target.x + 10)
			var ty = randi_range(target.y - 10, target.y + 10)
			target_move_position = Vector2(tx, ty)
			velocity = position.direction_to(target_move_position) * dash_speed
			
			animator.play("dash")
		
		States.DASH_STOP:
			velocity = Vector2.ZERO
			timer.wait_time = 0.5
			timer.start()
			
			animator.play("dash stop")
			
		States.HURT:
			velocity = Vector2.ZERO
			timer.wait_time = 0.5
			timer.start()
			
			animator.play("hurt")
			
		States.DEATH:
			animator.play("death")
			
	state = new_state
	print("ANIMATOR CHANGED TO: ", animator.animation)


func decide_next_attack() -> void:
	var distance = position.distance_to(target)
	
	# Transition to WALK STATE if player is far away
	if distance > 150:
		set_state(States.WALK)
	elif distance > 75:
		# Transition to DASH or FIRING state if player is close
		var r = randi_range(0, 1)
		if r == 0:
			set_state(States.DASH_PREPARATION)
		if r == 1:
			set_state(States.FIRING)
	else:
		set_state(States.DASH_PREPARATION)


func try_hurt(amount: int) -> void:
	# Do not damage boss if these states are active
	if state == States.DASH_PREPARATION or state == States.DASH or state == States.DASH_STOP:
		return
	
	if state == States.HURT or state == States.DEATH:
		return
	
	health -= amount
	set_state(States.HURT)


# TODO: Call damage function based on collision shape
func _on_collision_shape_2d_child_entered_tree(_node: Node) -> void:
	pass
