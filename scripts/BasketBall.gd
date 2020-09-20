extends RigidBody2D

export var max_speed_change : float = 250

onready var _spawn_position : Vector2 = global_position
onready var _audio : Node = get_node("AudioStreamPlayer")

var _old_velocity : Vector2

func _ready():
	connect("body_entered", self, "_on_body_entered")

# Respawn ball
func _physics_process(_delta):
	if global_position.y > 800:
		global_position = _spawn_position
		linear_velocity = Vector2(0.0, 0.0)
	_old_velocity = linear_velocity

func _on_body_entered(body):
	var speed_change : float = (linear_velocity - _old_velocity).length()
	_audio.volume_db = - 20.0 + 20.0 * min(speed_change / max_speed_change, 1.0)
	print(_audio.volume_db)
	_audio.play()