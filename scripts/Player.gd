extends KinematicBody2D

enum States { 
			  IDLE,
			  JUMPING,
			  WALKING,
			  FALLING 
			}

var _state : int = States.IDLE

export var _velocity : Vector2

export var friction : float = 2000
export var acceleration : float = 2500
export var air_acceleration : float = 1500
export var max_speed : float = 250
export var jump_force : float = 2500

export var jump_time : float = 0.15

export var gravity : float = 1000

export var max_animation_speed : float = 250
export var walk_amplitude : float = 20.0

onready var foot_pivot = get_node("FootPivot")

onready var foot_l = get_node("FootPivot/FootLPivot/FootL")
onready var foot_r = get_node("FootPivot/FootRPivot/FootR")

onready var _raycast = get_node("RayCast2D")

var _cycle_time : float = 0.0
var _airtime : float = 0.0

func _process(delta):
	_walk_cycle(delta)
	_movement(delta)

func _enter_state(new_state : int):
	print("entering state: ", States.keys()[new_state])
	_state = new_state

func _walk_cycle(delta: float):
	var floor_normal : Vector2 = _raycast.get_collision_normal()
	foot_pivot.rotation = -floor_normal.angle_to(Vector2(0.0, -1.0))
	_cycle_time += 0.1 * delta * _velocity.length() * sign(_velocity.x)
	var relative_walk_speed = min(1.0, abs(_velocity.x) / max_animation_speed)
	var dynamic_amplitude = walk_amplitude * relative_walk_speed
	foot_l.offset.y = - dynamic_amplitude
	foot_r.offset.y = - dynamic_amplitude
	foot_l.position = dynamic_amplitude * Vector2(cos(_cycle_time), sin(_cycle_time))
	foot_r.position = dynamic_amplitude *  Vector2(cos(_cycle_time + PI), sin(_cycle_time + PI))

func _movement(delta):
	if _state == States.IDLE or _state == States.WALKING:
		var floor_normal = _raycast.get_collision_normal()
		var floor_dir = Vector2(-floor_normal.y, floor_normal.x)
		if Input.is_action_pressed("walk_right"):
			if _velocity.dot(floor_dir) < max_speed:
				_velocity += acceleration * delta * floor_dir
		if Input.is_action_pressed("walk_left"):
			if -_velocity.dot(floor_dir) < max_speed:
				_velocity -= acceleration * delta * floor_dir
		if not Input.is_action_pressed("walk_right") and not Input.is_action_pressed("walk_left"):
			_velocity -= sign(_velocity.dot(floor_dir)) * min(friction * delta, abs(_velocity.dot(floor_dir))) * floor_dir

		if Input.is_action_pressed("jump"):
			print("JUMP")
			_velocity.y -= jump_force * delta
			_airtime = 0.0
			_enter_state(States.JUMPING)

		# Only set the state to falling if a certain distance of ground
		# and apply some gravity if the player is slightly off-ground
		# to make the player "stick" to inclines
		if not is_on_floor() and _get_floor_distance() > 5.0:
			_enter_state(States.FALLING)

		if not is_on_floor():
			_velocity.y += gravity * delta
		else:
			_velocity -= _velocity.dot(floor_normal) * floor_normal
		

	elif _state == States.JUMPING:
		if Input.is_action_pressed("jump") and _airtime < jump_time:
			_velocity.y -= jump_force * delta
		else:
			_enter_state(States.FALLING)
		_airtime += delta


	elif _state == States.FALLING:
		if is_on_floor():
			_velocity.y = 0.0
			_enter_state(States.WALKING)

		if Input.is_action_pressed("walk_right"):
			if _velocity.x < max_speed:
				_velocity.x += air_acceleration * delta
		if Input.is_action_pressed("walk_left"):
			if -_velocity.x < max_speed:
				_velocity.x -= air_acceleration * delta

	if not is_on_floor() and _state != States.JUMPING:
		_velocity.y += gravity * delta
	elif _state != States.JUMPING:
		var floor_normal = _raycast.get_collision_normal()
		_velocity -= _velocity.dot(floor_normal) * floor_normal

	move_and_slide(_velocity, Vector2(0.0, -1.0), true)

func _get_floor_distance():
	return _raycast.get_collision_point().y - global_position.y - 35
