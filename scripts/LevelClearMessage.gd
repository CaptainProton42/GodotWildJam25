extends Control

signal continue_pressed
signal retry_pressed

onready var _animation_player = get_node("AnimationPlayer")
onready var _button_retry = get_node("ButtonRetry")
onready var _button_continue = get_node("ButtonContinue")
onready var _audio_paper = get_node("AudioPaper")
onready var _audio_horn = get_node("AudioHorn")

func _ready():
	_button_retry.connect("pressed", self, "_on_retry_pressed")
	_button_continue.connect("pressed", self, "_on_continue_pressed")

func open():
	_audio_horn.play()
	visible = true
	_animation_player.play("open")

func close():
	_audio_paper.play()
	_animation_player.play_backwards("open")
	yield(_animation_player, "animation_finished")
	visible = false

func _on_continue_pressed():
	emit_signal("continue_pressed")

func _on_retry_pressed():
	emit_signal("retry_pressed")