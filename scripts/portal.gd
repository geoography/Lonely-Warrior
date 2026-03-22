extends Area2D

@export var required_keys: int = 8

var is_active = true

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var notif_label = $"../../NotificationLabel"
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	
	var remaining_keys = required_keys - GameManager.key_count
	if remaining_keys > 0:
		show_notification("Temukan %d kunci lagi!" % remaining_keys, Color.CYAN)
		return  
	
	is_active = false
	
	show_notification("Semua kunci terkumpul!", Color.GOLD)
	
	await get_tree().create_timer(2.0).timeout
	
	if animation_player and animation_player.has_animation("entering"):
		animation_player.play("entering")
		await animation_player.animation_finished
	
	body.visible = false
	body.set_process(false)
	body.set_physics_process(false)
	if body is CharacterBody2D:
		body.collision_layer = 0
		body.collision_mask = 0
	
	if sprite: sprite.visible = false
	if collision: collision.set_deferred("disabled", true)

func show_notification(text: String, warna: Color):
	if notif_label:
		notif_label.text = text
		notif_label.modulate = warna
		notif_label.visible = true
		
		await get_tree().create_timer(3.0).timeout
		if is_instance_valid(notif_label) and notif_label.text == text:
			notif_label.visible = false
