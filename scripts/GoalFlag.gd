extends Area2D

signal triggered

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body : Node):
	if body.name == "Player":
		print("yay")
		emit_signal("triggered")