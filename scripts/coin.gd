extends Area2D

@export var coin_id: String 
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	if GameManager.is_coin_collected(coin_id):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.add_coin()
		GameManager.mark_coin_collected(coin_id)  
		
		if animation_player:
			animation_player.play("pickup")
			await animation_player.animation_finished
		queue_free()
