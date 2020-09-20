extends StaticBody2D

onready var _trigger = get_node("Trigger")

var _tracked_rigid_bodies = []

signal triggered

func _ready():
	_trigger.connect("body_entered", self, "_on_body_entered")
	_trigger.connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body : Node):
	if body is RigidBody2D:
		_tracked_rigid_bodies.append({"body" : body, "last_position" : body.position - position })

func _on_body_exited(body : Node):
	for i in range(_tracked_rigid_bodies.size()):
		if _tracked_rigid_bodies[i]["body"] == body:
			_tracked_rigid_bodies.remove(i)
			return

func _physics_process(delta):
	for d in _tracked_rigid_bodies:
		var new_pos : Vector2 = d["body"].position - position
		if new_pos.y > 0.0 and d["last_position"].y < 0.0:
			emit_signal("triggered")
		d["last_position"] = new_pos
