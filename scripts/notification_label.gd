extends Label

@onready var player = get_node("../Player")

func _process(delta):
	if player:
		global_position = player.global_position + Vector2(-35, -50)
