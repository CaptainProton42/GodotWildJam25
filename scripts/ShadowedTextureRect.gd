tool
extends TextureRect
class_name ShadowedTextureRect

export var shadow_texture : Texture setget set_shadow_texture, get_shadow_texture
export var shadow_distance : float = 3.0 setget set_shadow_distance, get_shadow_distance
export var shadow_direction : Vector2 = Vector2(0.0, 1.0) setget set_shadow_direction, get_shadow_direction

var _shadow : TextureRect
var _shadow_texture : Texture
var _shadow_distance : float
var _shadow_direction : Vector2

func _ready():
	_shadow = TextureRect.new()
	_shadow.show_behind_parent = true
	_shadow.texture = _shadow_texture
	add_child(_shadow)
	connect("item_rect_changed", self, "_on_item_rect_changed")

func _process(_delta):
	_shadow.rect_global_position

func set_shadow_texture(t : Texture):
	_shadow_texture = t
	if is_inside_tree():
		_shadow.texture = _shadow_texture

func get_shadow_texture() -> Texture:
	return _shadow_texture

func set_shadow_distance(d : float):
	_shadow_distance = d
	if is_inside_tree():
		_on_item_rect_changed()

func get_shadow_distance() -> float:
	return _shadow_distance


func set_shadow_direction(d : Vector2):
	_shadow_direction = d
	if is_inside_tree():
		_on_item_rect_changed()

func get_shadow_direction() -> Vector2:
	return _shadow_direction

func _on_item_rect_changed():
	_shadow.rect_global_position = rect_global_position + _shadow_direction * _shadow_distance