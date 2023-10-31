extends Control
signal start_game
@onready var lives_counter = $MarginContainer/HBoxContainer/LivesCounter.get_children()
@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var message = $VBoxContainer/Message
@onready var start_button = $VBoxContainer/StartButton
@onready var shield_bar = $MarginContainer/HBoxContainer/ShieldBar

var bar_textures = {
	"green": preload("res://assets/bar_green_200.png"),
	"yellow": preload("res://assets/bar_yellow_200.png"),
	"red": preload("res://assets/bar_red_200.png")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text: String):
	message.text = text
	message.show()
	$Timer.start()


func update_score(value: int):
	score_label.text = str(value)


func update_lives(value: int):
	for item in 3:
		lives_counter[item].visible = value > item


func game_over():
	show_message("Game Over")
	await $Timer.timeout
	start_button.show()


func update_shield(value: float):
	shield_bar.texture_progress = bar_textures["green"]
	if value < 0.4:
		shield_bar.texture_progress = bar_textures["yellow"]
	elif value < 0.7:
		shield_bar.texture_progress = bar_textures["red"]
	shield_bar.value = value
	


func _on_start_button_pressed():
	start_button.hide()
	start_game.emit()


func _on_timer_timeout():
	message.hide()
	message.text = ""


func _on_player_shield_changed(value) -> void:
	update_shield(value)
