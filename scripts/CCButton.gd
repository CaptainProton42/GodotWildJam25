extends TextureButton

func _ready():
	connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	print("lel")
	get_node("../Attributions").visible = !get_node("../Attributions").visible