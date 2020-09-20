extends RigidBody2D

onready var _spawn_position : Vector2 = global_position

func _ready():
	connect("body_entered", self, "_on_body_entered")

# Respawn ball
func _physics_process(_delta):
	if global_position.y > 800:
		global_position = _spawn_position
		linear_velocity = Vector2(0.0, 0.0)