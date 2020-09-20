extends Control

onready var _eraser : Node = get_node("Eraser")
onready var _animation_player : Node = get_node("AnimationPlayer")

export var line_drawing : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	_eraser.connect("mouse_entered", self, "_on_mouse_entered")
	_eraser.connect("mouse_exited", self, "_on_mouse_exited")
	_eraser.connect("gui_input", self, "_on_gui_input")

func _on_mouse_entered():
	_animation_player.play("mouseover")

func _on_mouse_exited():
	_animation_player.play_backwards("mouseover")

func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		get_node(line_drawing).clear_drawing()
