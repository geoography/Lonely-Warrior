extends ConfirmationDialog

signal answered(is_correct)
signal popup_closed

@onready var question_label = $CenterContainer/VBoxContainer/QuestionText
@onready var answer_input = $CenterContainer/VBoxContainer/AnswerInput

var current_answer = ""
var is_active = false

func _ready() -> void:
	confirmed.connect(_on_submit_pressed)
	canceled.connect(_on_force_close)
	close_requested.connect(_on_force_close)
	hide()
	
func show_question(text_soal: String, kunci_jawaban: String) -> void:
	if is_active:
		return 
	
	is_active = true
	question_label.text = text_soal
	current_answer = kunci_jawaban
	answer_input.text = ""
	
	popup_centered(Vector2i(400, 250)) 
	
	await get_tree().process_frame
	answer_input.grab_focus()

func _on_submit_pressed() -> void:
	var player_ans = answer_input.text.strip_edges()
	
	if player_ans.is_empty():
		return
	
	var is_correct = player_ans.to_lower() == current_answer.to_lower()
	
	emit_signal("answered", is_correct)
	_finalize_popup() 

func _on_force_close() -> void:
	emit_signal("answered", false) 
	_finalize_popup()

func _finalize_popup() -> void:
	hide()
	is_active = false
	current_answer = ""
	emit_signal("popup_closed")
