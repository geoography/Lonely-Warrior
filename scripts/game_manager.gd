extends Node

var coin_count: int = 0
var key_count: int = 0
var checkpoint_position: Vector2 = Vector2(-95, -104)

var collected_coins: Array = []
var opened_treasures: Array = []

func add_coin(amount: int = 1) -> void:
	coin_count += amount

func remove_coin(amount: int = 1) -> bool:
	if coin_count >= amount:
		coin_count -= amount
		return true
	return false

func add_key(amount: int = 1) -> void:
	key_count += amount

func get_key_count() -> int:
	return key_count

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos

func get_checkpoint() -> Vector2:
	return checkpoint_position

func mark_coin_collected(coin_id: String) -> void:
	if not collected_coins.has(coin_id):
		collected_coins.append(coin_id)

func is_coin_collected(coin_id: String) -> bool:
	return collected_coins.has(coin_id)

func mark_treasure_opened(treasure_id: String) -> void:
	if not opened_treasures.has(treasure_id):
		opened_treasures.append(treasure_id)

func is_treasure_opened(treasure_id: String) -> bool:
	return opened_treasures.has(treasure_id)
