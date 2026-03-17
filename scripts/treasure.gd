extends Area2D

const required_coins = 5
const KEY_SCENE_PATH = "res://scenes/key.tscn"

@export_multiline var soal_ini: String  
@export var jawaban_ini: String
@export var treasure_id: String

var key_spawned = false
var player_in_area = false
var is_opened = false
var is_quiz_active = false
var is_question_done = false

@onready var animation_player = $AnimationPlayer
@onready var question_ui = get_node("/root/Game/QuestionPopup")
@onready var notif_label = $"../../NotificationLabel"
@onready var key_scene = load(KEY_SCENE_PATH)

func _ready() -> void:
	print("🆔 [TREASURE %s] Ready! GM Instance ID: %s" % [treasure_id, GameManager.get_instance_id()])
	
	if GameManager.is_treasure_opened(treasure_id):
		is_question_done = true
		is_opened = true
		monitoring = false
		monitorable = false
		
		if animation_player and animation_player.has_animation("open"):
			animation_player.play("open")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_area = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		if is_quiz_active and question_ui and question_ui.visible:
			question_ui.hide()
			is_quiz_active = false
			monitoring = true
			monitorable = true

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact") and not is_quiz_active:
		if is_question_done:
			return
		if not is_opened:
			
			if GameManager.coin_count < required_coins:
				show_notification("Koin Kurang! \nButuh %d koin." % required_coins, Color.ORANGE)
				if animation_player and animation_player.has_animation("locked"):
					animation_player.play("locked", 0.0)
				return
			
			animation_player.play("open", 0.0)
			is_opened = true 
			tampilkan_soal()
		elif is_opened and not is_question_done:
			tampilkan_soal()

func tampilkan_soal():
	if question_ui:
		is_quiz_active = true
		monitoring = false
		monitorable = false
		
		question_ui.show_question(soal_ini, jawaban_ini)
		
		if not question_ui.answered.is_connected(_on_soal_dijawab):
			question_ui.answered.connect(_on_soal_dijawab)
		if not question_ui.popup_closed.is_connected(_on_popup_closed_manual):
			question_ui.popup_closed.connect(_on_popup_closed_manual)
	else:
		selesaikan_peti(true)

func _on_soal_dijawab(is_correct: bool):
	selesaikan_peti(is_correct)

func selesaikan_peti(berhasil: bool):
	if berhasil:
		if key_scene and not key_spawned:
			var key = key_scene.instantiate()
			var game_root = get_node("/root/Game")
			
			game_root.add_child(key)
			key.global_position = global_position + Vector2(0, -50)
			
			if "game_manager" in key:
				key.game_manager = GameManager
			
			key_spawned = true
			show_notification("Dapat Kunci!", Color.GOLD)
		
		if GameManager.coin_count >= required_coins:
			GameManager.coin_count -= required_coins
			print("💰 [TREASURE] Paid: -%d coins | Remaining: %d" % [
				required_coins, GameManager.coin_count])
		else:
			# ⚠️ Edge case: koin habis di tengah-tengah (jarang terjadi)
			print("⚠️ [TREASURE] Warning: Not enough coins to pay after spawning key!")
			show_notification("Koin tidak cukup untuk bayar!", Color.RED)
		
		is_question_done = true
		GameManager.set_checkpoint(global_position + Vector2(0, -100))
		GameManager.mark_treasure_opened(treasure_id)
	else:
		show_notification("SALAH! Coba lagi.", Color.RED)
		tampilkan_soal()

func _on_popup_closed_manual():
	is_quiz_active = false
	monitoring = true
	monitorable = true

func show_notification(text: String, warna: Color):
	if notif_label:
		notif_label.text = text
		notif_label.modulate = warna
		notif_label.visible = true
		
		await get_tree().create_timer(3.0).timeout
		if is_instance_valid(notif_label) and notif_label.text == text:
			notif_label.visible = false
