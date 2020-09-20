extends Node

export var character_creator_path : NodePath

onready var _character_creator : Node = get_node(character_creator_path)
onready var _player : Node
onready var _level : Node = get_parent()

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	_character_creator.open()
	yield(_character_creator, "finished")
	_player = _character_creator.create_character()
	_player.scale = Vector2(0.3, 0.3)
	_player.position = Vector2(100, 500)
	add_child(_player)
	_character_creator.close()
	get_node("RigidBody2D").sleeping = false