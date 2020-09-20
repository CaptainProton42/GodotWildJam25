extends Node2D

export var character_creator_path : NodePath
export var world_path : NodePath
export var retry_button_path : NodePath
export var celebration_particles_path : NodePath
export var level_clear_message_path : NodePath

export(String, FILE) var title_screen : String

onready var _character_creator : Node = get_node(character_creator_path)
onready var _player : Node
onready var _world : Node = get_node(world_path)
onready var _retry_button : Node = get_node(retry_button_path)
onready var _celebration_particles : Node = get_node(celebration_particles_path)
onready var _level_clear_message : Node = get_node(level_clear_message_path)
onready var _spawn_point : Node
onready var _goal_trigger : Node

var _levels = [preload("res://scenes/Level1.tscn"),
			   preload("res://scenes/Level2.tscn"),
			   preload("res://scenes/Level3.tscn")]

var _cur_level : Node = null
var _cur_level_idx = 0

func _ready():
	_retry_button.connect("pressed", self, "_restart")
	_level_clear_message.connect("retry_pressed", self, "_on_retry_pressed")
	_level_clear_message.connect("continue_pressed", self, "_load_next_level")

	_restart()

func _restart():
	if get_node("LevelContainer").get_child_count() > 0:
		get_node("LevelContainer").get_child(0).queue_free()
	_cur_level = _levels[_cur_level_idx].instance()
	get_node("LevelContainer").add_child(_cur_level)

	_goal_trigger = _cur_level.get_node("GoalFlag")
	_spawn_point = _cur_level.get_node("SpawnPoint")

	Physics2DServer.set_active(false)
	yield(_character_creation(), "completed")
	Physics2DServer.set_active(true)

	_goal_trigger.connect("triggered", self, "_on_goal_triggered")

func _character_creation():
	_character_creator.open()
	yield(_character_creator, "finished")
	_player = _character_creator.create_character()
	_player.scale = Vector2(0.3, 0.3)
	_player.position = _spawn_point.position
	_cur_level.add_child(_player)
	_character_creator.close()

func _on_retry_pressed():
	yield(_level_clear_message.close(), "completed")
	_restart()

func _on_goal_triggered():
	Physics2DServer.set_active(false)
	_player.set_process(false)
	_celebration_particles.emitting = true
	_level_clear_message.open()

func _load_next_level():
	if _cur_level_idx == _levels.size() - 1:
		get_tree().change_scene(title_screen)
	_cur_level_idx += 1
	yield(_level_clear_message.close(), "completed")
	_restart()
