extends Node

var projectile_list : Array

enum projectiles {test}

var max_lifetime : Dictionary = {
	projectiles.test : 3
}

var damage : Dictionary = {
	projectiles.test : 3
}

var spritesheet : Dictionary = {
	"test_bullet" : "res://Resources/SpriteFrames/Bullets/test_bullet.tres"
}

var collision : Dictionary = {
	"test_bullet" : "res://Resources/Collisions/Bullets/test_bullet.tres"
}

@export var bullet_count : int = 20
@export var active_bullets : int = 10

func _ready() -> void:
	for x in bullet_count:
		pass
