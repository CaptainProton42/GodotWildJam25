extends TextureProgress

export var line_drawing : NodePath

func _ready():
	get_node(line_drawing).connect("drawing_changed", self, "_on_drawing_changed")

func _on_drawing_changed():
	value = get_node(line_drawing).get_remaining_ink_percentage()
