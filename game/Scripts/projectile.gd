extends Area2D


var type: projectile_manager.ProjectileType
var dead: bool
var time_alive: float
var velocity: Vector2

var max_lifetime: float
var damage: float
var speed: float
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer


# TODO: If collided with player or boss, deal damage then set to dead
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if type == projectile_manager.ProjectileType.BASIC:
			return
		dead = true
		# TODO Call player take damage function
	elif body.is_in_group("enemy"):
		# TODO: Return if type of projectile is an enemy projectile
		dead = true
		# TODO Call boss take damage function
	else:
		dead = true


func _on_timer_timeout() -> void:
	print("DIE GODAMn it")
	print(dead)
	if dead:
		visible = false


func spawn() -> void:
	animator.play("move")
	visible = true


func destroy() -> void:
	velocity = Vector2.ZERO
	dead = true
	animator.play("hit")
	timer.start()
