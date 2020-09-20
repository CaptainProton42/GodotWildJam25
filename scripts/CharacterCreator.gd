extends Control

signal finished

var _player_scene = preload("res://scenes/Player.tscn")


onready var _line_drawing : Node = get_node("LineDrawing")
onready var _confirm_button : Node = get_node("ConfirmButton")
onready var _animation_player = get_node("AnimationPlayer")
onready var _audio = get_node("AudioStreamPlayer")

func open():
	_audio.play()
	_animation_player.play("open")

func close():
	_audio.play()
	_animation_player.play_backwards("open")
	yield(_animation_player, "animation_finished")
	visible = false

func _ready():
	_confirm_button.connect("pressed", self, "_on_button_pressed")

func create_character() -> Node:
	var player : Node = _player_scene.instance()
	for c in _line_drawing.get_physics_body_children():
		var c_ = c.duplicate()
		player.add_child(c_)
		c_.position = _line_drawing.rect_position - get_node("FakePlayer").position
	return player

func _on_button_pressed():
	emit_signal("finished")
