extends Area2D

@onready var timer = $Timer
@onready var hurt_sound = $HurtSound

func _on_body_entered(body: Node2D) -> void:
	hurt_sound.play()
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
