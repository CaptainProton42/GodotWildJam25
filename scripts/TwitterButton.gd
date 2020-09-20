extends TextureButton

func _ready():
	connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	OS.shell_open("https://twitter.com/CaptainProton42")