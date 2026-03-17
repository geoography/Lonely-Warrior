extends CanvasLayer

@onready var coin_label = $VBoxContainer/CoinContainer/CoinCount
@onready var key_label = $VBoxContainer/KeyContainer/KeyCount

func _process(_delta: float) -> void:
	coin_label.text = "x %d" % GameManager.coin_count
	key_label.text = "x %d" % GameManager.key_count
