extends Node


# NOTE: Please keep DEAD at start of enum definition
enum ProjectileType {BASIC}


var max_lifetime : Dictionary = {
	ProjectileType.BASIC : 3,
}

var damage : Dictionary = {
	ProjectileType.BASIC : 3,
}

var speed : Dictionary = {
	ProjectileType.BASIC : 200,
}

var spritesheet : Dictionary = {
	ProjectileType.BASIC : "res://Resources/SpriteFrames/Bullets/BASIC_bullet.tres",
}

var collision : Dictionary = {
	ProjectileType.BASIC : "res://Resources/Collisions/Bullets/BASIC_bullet.tres",
}


var projectile_scene = preload("res://Scenes/projectile.tscn")

var object_pool : Array
@export var max_projectiles : int = 100
var active_projectiles : int = 0


func _ready() -> void:
	for i in range(max_projectiles):
		var new_projectile = projectile_scene.instantiate()
		
		# Do not initialise other values
		new_projectile.dead = true
		
		new_projectile.visible = false
		
		object_pool.append(new_projectile)


# Why physics_process over process here?
func _physics_process(delta: float) -> void:
	# Loop through object pool backwards
	for i in range(active_projectiles - 1, -1, -1):
		var projectile = object_pool[i]
		
		# If projectile needs to be killed, keep the array packed!
		if projectile.dead or projectile.time_alive > projectile.max_lifetime:
			# Pack it up baby
			# If last one just decrement
			if i != active_projectiles - 1:
				# Move valid one at last position into current spot
				# Since we iterated backwards it would have already run this frame
				object_pool[i] = object_pool[active_projectiles]
				
			# Decrement active_projectiles
			active_projectiles -= 1
			continue
		
		match projectile.type:
			ProjectileType.BASIC:
				projectile.position += projectile.velocity * projectile.speed * delta
		
		# No matter the projectile type add elasped time to time_alive
		projectile.time_alive += delta


func init_projectile(projectile, type: ProjectileType, position: Vector2, velocity: Vector2) -> void:
	projectile.type = type
	projectile.dead = false
	projectile.position = position
	projectile.velocity = velocity
	
	projectile.max_lifetime = max_lifetime[type]
	projectile.damage = damage[type]
	projectile.speed = speed[type]

	projectile.animator = spritesheet[type]
	projectile.collision = collision[type]
	
	projectile.visible = true


# This function should be called by player and boss and enemies :)
func spawn_projectile(type: ProjectileType, position: Vector2, velocity: Vector2) -> void:
	if active_projectiles >= max_projectiles:
		return

	var projectile_to_spawn = object_pool[active_projectiles]
	
	init_projectile(projectile_to_spawn, type, position, velocity)
	
	active_projectiles += 1
