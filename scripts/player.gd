#extends CharacterBody2D
#
#const SPEED = 160.0
#const JUMP_VELOCITY = -320.0
#const COYOTE_TIME = 0.15 
#
#var current_friction: float = 0.2
#var is_on_ice: bool = false
#
#@onready var animated_sprite = $AnimatedSprite2D
#
#var coyote_timer := 0.0
#
#func _ready() -> void:
	#var spawn_pos = GameManager.get_checkpoint()
	#global_position = spawn_pos
#
#func _physics_process(delta: float) -> void:
	#_check_surface()
	#
	#if is_on_floor():
		#coyote_timer = COYOTE_TIME
	#else:
		#coyote_timer -= delta
#
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	#if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		#velocity.y = JUMP_VELOCITY
		#coyote_timer = 0
#
	#var direction := Input.get_axis("move_left", "move_right")
	#
	#if direction > 0: animated_sprite.flip_h = false
	#elif direction < 0: animated_sprite.flip_h = true
	#
	#if is_on_floor():
		#animated_sprite.play("idle" if direction == 0 else "run")
	#else:
		#animated_sprite.play("jump") 
	#
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED * current_friction)
#
	#move_and_slide()
#
#func _check_surface() -> void:
	#if not is_on_floor():
		#is_on_ice = false
		#current_friction = 0.2
		#return
	#
	#var space_state = get_world_2d().direct_space_state
	#var query = PhysicsRayQueryParameters2D.create(
		#global_position + Vector2(0, -10),
		#global_position + Vector2(0, 20)
	#)
	#query.exclude = [self]
	#query.collision_mask = 1
	#
	#var result = space_state.intersect_ray(query)
	#
	#if result:
		#var collider = result.collider
		#
		#if is_instance_of(collider, TileMapLayer):
			#var tile_map_layer = collider as TileMapLayer
			#var tile_pos = tile_map_layer.local_to_map(result.position)
			#
			#var tile_data = tile_map_layer.get_cell_tile_data(tile_pos)
			#
			#if tile_data:
				#var surface = tile_data.get_custom_data("surface_type")
				#
				#if surface == "ice":
					#is_on_ice = true
					#current_friction = 0.01
				#else:
					#is_on_ice = false
					#current_friction = 0.2
				#return
		#
		#elif collider.is_in_group("ice_platform"):
			#is_on_ice = true
			#current_friction = 0.01
			#return
		#
		## Normal surface
		#is_on_ice = false
		#current_friction = 0.2
		#return
	#
	#is_on_ice = false
	#current_friction = 0.2

extends CharacterBody2D

const SPEED = 160.0
const GRAVITY = 980.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	var spawn_pos = GameManager.get_checkpoint()
	global_position = spawn_pos

func _physics_process(delta: float) -> void:
	# Gravitasi selalu aktif (Flappy Style)
	velocity.y += GRAVITY * delta

	# Lompat tanpa syarat lantai
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")
	else:
		# Animasi sederhana berdasarkan velocity
		if velocity.y > 0:
			animated_sprite.play("jump") # Atau 'fall'
		else:
			animated_sprite.play("jump") # Atau 'fly'

	# Horizontal Movement (Opsional)
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0: animated_sprite.flip_h = false
	elif direction < 0: animated_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.2) # Air resistance

	move_and_slide()
