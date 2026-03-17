extends Node2D

const SPEED = 75.0

var direction = 1
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_ground_right = $RayCastGroundRight
@onready var ray_cast_ground_left = $RayCastGroundLeft
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void: 
	
	# Cek Kanan: Tembok ATAU Jurang
	if ray_cast_right.is_colliding() or not ray_cast_ground_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
		
	# Cek Kiri: Tembok ATAU Jurang
	elif ray_cast_left.is_colliding() or not ray_cast_ground_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
