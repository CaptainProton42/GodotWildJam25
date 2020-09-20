extends Resource
class_name Drawing

var _points : PoolVector2Array = []
var _mesh : MeshInstance2D = MeshInstance2D.new()
var _collision_polygon : CollisionPolygon2D = CollisionPolygon2D.new()
var _texture_size : Vector2
var _line_width : float
var _line_color : Color

func append_point(p : Vector2):
	_points.append(p)
	_generate_mesh()

func _generate_mesh():
	# TODO: A mesh with only a single point should be generated
	# as a point
	if _points.size() < 2:
		return
	var vertices : PoolVector3Array = PoolVector3Array()
	var uvs : PoolVector2Array = PoolVector2Array()
	var path_time : float = 0.0

	var polygon : PoolVector2Array = PoolVector2Array()
	polygon.resize(2 * _points.size())
	for i in range(_points.size()):
		var pt : Vector2 = _points[i]
		
		# Vertices
		var dir : Vector2
		if (i < _points.size() - 1):
			dir = _points[i+1] - pt
		else:
			dir = pt - _points[i-1]
		var normal : Vector2 = Vector2(-dir.y, dir.x).normalized()
			
		vertices.push_back(Vector3(pt.x, pt.y, 0.0) + 0.5 * _line_width * Vector3(normal.x, normal.y, 0.0))
		vertices.push_back(Vector3(pt.x, pt.y, 0.0) - 0.5 * _line_width * Vector3(normal.x, normal.y, 0.0))

		# UVs
		if (i > 0):
			path_time += _texture_size.y / _texture_size.x / _line_width * (pt - _points[i-1]).length()

		uvs.push_back(Vector2(path_time, 1.0))
		uvs.push_back(Vector2(path_time, 0.0))

		# Collision polygon
		polygon[i] = pt + 0.5 * _line_width * normal
		polygon[polygon.size() - 1 - i] = pt - 0.5 * _line_width * normal

	var arr_mesh = ArrayMesh.new()
	var arrays : Array = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs

	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	_mesh.mesh = arr_mesh
	_mesh.self_modulate = _line_color

	_collision_polygon.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
	_collision_polygon.polygon = polygon


func get_mesh() -> MeshInstance2D:
	return _mesh

func get_points() -> PoolVector2Array:
	return _points

func get_collision_polygon() -> CollisionPolygon2D:
	return _collision_polygon
