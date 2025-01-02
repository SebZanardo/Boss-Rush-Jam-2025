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


func _on_collision_shape_2d_child_entered_tree(_node: Node) -> void:
	# TODO: If collided with wall just set to dead
	# TODO: If collided with player or boss, deal damage then set to dead
	dead = true
	
