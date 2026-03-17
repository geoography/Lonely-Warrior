extends Area2D

@onready var animation_player = $AnimationPlayer

func _ready():
	# Animasi muncul
	var tween = create_tween()
	position.y += 20
	modulate.a = 0
	
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.tween_property(self, "position:y", position.y - 40, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y + 40, 0.4).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "rotation", deg_to_rad(360), 1.0).from_current()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.add_key()
		print("kunci: ",GameManager.key_count)
		animation_player.play("Get")
		await animation_player.animation_finished
		queue_free()
