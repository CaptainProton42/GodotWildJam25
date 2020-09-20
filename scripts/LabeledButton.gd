extends TextureButton

export var button_text : String

onready var label = get_node("Label")
var _label_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = button_text
	_label_offset = label.rect_position
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")

func _on_button_down():
	label.rect_position = _label_offset + Vector2(-60.0, 60.0)

func _on_button_up():
	label.rect_position = _label_offset + Vector2(0.0, 0.0)