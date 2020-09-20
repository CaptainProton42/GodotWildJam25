extends Control
class_name LineDrawing2D

signal drawing_changed

enum PhysicsModes {
	STATIC,
	KINEMATIC,
	RIGID
}

var _drawings : Array = []
var _meshes : Array = []
var _current_drawing : Drawing = null

var _pen_down : bool = false
var _draw_timer : float = 0.0
var _old_pen_pos : Vector2 = Vector2(0.0, 0.0)

var _spent_ink : float = 0.0

var _physics_body : PhysicsBody2D = null

var _audio : AudioStreamPlayer = AudioStreamPlayer.new()

export(PhysicsModes) var physics_mode : int = PhysicsModes.STATIC

export var draw_interval : float = 0.01
export var draw_min_dist : float = 1

export var line_tex : Texture
export var line_width : float = 10.0

export var available_ink : float = 3000.0

export var line_color : Color

export var audio_stream : AudioStream

func _ready():
	_audio.stream = audio_stream
	add_child(_audio)
	connect("gui_input", self, "_on_gui_input")
	match physics_mode:
		PhysicsModes.STATIC:
			_physics_body = StaticBody2D.new()
		PhysicsModes.KINEMATIC:
			_physics_body = KinematicBody2D.new()
		PhysicsModes.RIGID:
			_physics_body = RigidBody2D.new()

	add_child(_physics_body)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			_enter_draw_mode()
		else:
			_exit_draw_mode()
		
func _enter_draw_mode():
	if _spent_ink < available_ink:
		_audio.play()
		_pen_down = true
		_current_drawing = Drawing.new()
		_current_drawing._texture_size = line_tex.get_size()
		_current_drawing._line_width = line_width
		_current_drawing._line_color = line_color
		_drawings.append(_current_drawing)
		_physics_body.add_child(_current_drawing.get_mesh())
		_physics_body.add_child(_current_drawing.get_collision_polygon())
		_current_drawing.get_mesh().texture = line_tex
		_old_pen_pos = _physics_body.get_local_mouse_position()

func _exit_draw_mode():
	_audio.stop()
	_pen_down = false

func _process(delta):
	if _pen_down:
		# reset audio
		if _audio.get_playback_position() >= audio_stream.get_length():
			_audio.seek(0.0)
		if _spent_ink < available_ink:
			if _draw_timer > draw_interval:
				var cur_pen_pos : Vector2 = _physics_body.get_local_mouse_position()
				if cur_pen_pos.x > rect_size.x or cur_pen_pos.y > rect_size.y or cur_pen_pos.x < 0 or cur_pen_pos.y < 0:
					_exit_draw_mode()
					return
				_draw_timer -= draw_interval
				if (cur_pen_pos - _old_pen_pos).length() > draw_min_dist:
					_current_drawing.append_point(cur_pen_pos)
					emit_signal("drawing_changed")
				var dist_travelled = (cur_pen_pos - _old_pen_pos).length()
				_spent_ink += dist_travelled
				_old_pen_pos = cur_pen_pos
				_audio.volume_db = -20.0 + 20.0 * min(dist_travelled / 5.0, 1.0)
		else:
			_exit_draw_mode()
	_draw_timer += delta

func clear_drawing():
	_drawings = []
	_spent_ink = 0
	for child in _physics_body.get_children():
			_physics_body.remove_child(child)
	emit_signal("drawing_changed")

func get_remaining_ink_percentage() -> float:
	return (available_ink - _spent_ink) / available_ink * 100

# duplicate() has return type Node
func get_physics_body_duplicate() -> Node:
	return _physics_body.duplicate()

func get_physics_body_children() -> Array:
	return _physics_body.get_children()
