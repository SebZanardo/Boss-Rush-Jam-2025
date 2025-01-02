extends Area2D

var type : projectile_manager.projectile_type

var time_alive : float
var velocity : Vector2
var max_lifetime : float
var damage : float
var speed : float

@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
