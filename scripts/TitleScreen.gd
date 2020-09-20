extends Control

export(String, FILE) var level_manager : String

onready var _start_button = get_node("StartButton")

func _ready():
	_start_button.connect("pressed", self, "_on_start_pressed")

func _on_start_pressed():
	get_tree().change_scene(level_manager)