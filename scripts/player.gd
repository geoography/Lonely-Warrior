extends CharacterBody2D

const SPEED = 160.0
const JUMP_VELOCITY = -320.0
const COYOTE_TIME = 0.15 

@onready var animated_sprite = $AnimatedSprite2D

var coyote_timer := 0.0
var was_on_floor := false

func _ready() -> void:
	var spawn_pos = GameManager.get_checkpoint()
	global_position = spawn_pos

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0: animated_sprite.flip_h = false
	elif direction < 0: animated_sprite.flip_h = true
	
	if is_on_floor():
		animated_sprite.play("idle" if direction == 0 else "run")
	else:
		animated_sprite.play("jump") 
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
