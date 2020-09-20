extends Control

signal pressed

onready var _tab = get_node("TextureRect")
onready var _animation_player : Node = get_node("AnimationPlayer")

func _ready():
	_tab.connect("mouse_entered", self, "_on_mouse_entered")
	_tab.connect("mouse_exited", self, "_on_mouse_exited")
	_tab.connect("gui_input", self, "_on_gui_input")

func _on_mouse_entered():
	_animation_player.play("mouseover")

func _on_mouse_exited():
	_animation_player.play_backwards("mouseover")

func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("pressed")