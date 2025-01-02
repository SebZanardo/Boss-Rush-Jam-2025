extends Node

var projectile_list : Array

enum projectile_type {test}

var max_lifetime : Dictionary = {
	projectile_type.test : 3
}

var damage : Dictionary = {
	projectile_type.test : 3
}

var spritesheet : Dictionary = {
	projectile_type.test : "res://Resources/SpriteFrames/Bullets/test_bullet.tres"
}

var collision : Dictionary = {
	projectile_type.test : "res://Resources/Collisions/Bullets/test_bullet.tres"
}

var speed : Dictionary = {
	projectile_type.test : 200
}

var projectile_scene = preload("res://Scenes/bullet.tscn")

@export var bullet_count : int = 20
@export var active_bullets : int = 10

func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	for x in projectile_list:
		if x.time_alive < 0:
			continue
		match x.type: 
			projectile_type.test:
				x.global_position += x.speed * x.velocity * delta

func init_bullet(bullet):
	bullet.animator = spritesheet[bullet.type]
	bullet.collision = collision[bullet.type]
	bullet.max_lifetime = max_lifetime[bullet.type]
	bullet.damage = damage[bullet.type]
	bullet.speed = speed[bullet.type]

func spawn_bullets():
	projectile_list.clear()
	for x in active_bullets:
		var bullet = projectile_scene.instantiate()
		bullet.type = projectile_type.test
		init_bullet(bullet)
		projectile_list.append(bullet)
	var bullet_count : int = 0
