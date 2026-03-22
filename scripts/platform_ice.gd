extends AnimatableBody2D

@export var is_ice: bool = true

func _ready() -> void:
	if is_ice:
		add_to_group("ice_platform")
