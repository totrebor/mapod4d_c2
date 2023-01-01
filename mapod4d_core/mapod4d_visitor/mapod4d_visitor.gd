# tool

# class_name
class_name Mapod4dVistor

# extends
extends CharacterBody3D

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
## disable input
@export var input_disabled_flag: bool = true
## set current camera
@export var current_camera_flag: bool = false:
	## update internal camera
	set(new_current_camera):
		current_camera_flag = new_current_camera
		var camera = get_node_or_null("RotationHelper/Camera3d")
		if camera != null:
			camera.current = new_current_camera
## mouse orizzontal sensitivity
@export var oriz_mouse_sensitivity: float = 4
## mouse vertical sensitivity
@export var vert_mouse_sensitivity: float = 4
## coefficient of velocity reduction
@export var coef_vel_reduc: float = 3
## forwad speed multiplier
@export var forward_speed_multi: float = 1
## right speed multiplier
@export var right_speed_multi: float = 1
## up speed multiplier
@export var up_speed_multi: float = 0.5


# ----- public variables

# ----- private variables

# ----- onready variables
@onready var _input_rotation_vector = Vector2(0, 0)
#@onready var _input_movement_vector = Vector3(0, 0, 0)
@onready var _input_forward_speed := 0.0
@onready var _input_right_speed := 0.0
@onready var _input_up_speed := 0.0
@onready var _rotation_helper := $RotationHelper
@onready var _camera := $RotationHelper/Camera3d
@onready var _mapod := $Mapod
@onready var _mapod_visitor := $Mapod/MapodVisitor
@onready var _hud := $Hud
@onready var _keyboard_status = {
	"rotate_right" = false,
	"rotate_left" = false,
	"rotate_up" = false,
	"rotate_down" = false,
	"forward" = false,
	"backward" = false,
	"left" = false,
	"right" = false,
	"up" = false,
	"down" = false,
}
@onready var _joypad_values = {
}

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.use_accumulated_input = false
	_camera.current = current_camera_flag


# ----- remaining built-in virtual methods

func _handle_tick(delta):
	_elab_keyboard()
	_elab_joypad()
	
	var input_rotation = Vector2(_input_rotation_vector.y, _input_rotation_vector.x)
	var local_rotation = Vector2(0, 0)
	var local_forward_speed = 0.0
	var local_right_speed = 0.0
	var local_up_speed = 0.0

	## data linear interpolated
	local_rotation.x = lerp(local_rotation.x, input_rotation.x, delta * vert_mouse_sensitivity)
	local_rotation.y = lerp(local_rotation.y, input_rotation.y, delta * oriz_mouse_sensitivity)
	local_forward_speed = lerp(
			_input_forward_speed * forward_speed_multi, local_forward_speed, delta * coef_vel_reduc)
	local_right_speed = lerp(
			_input_right_speed * right_speed_multi, local_right_speed, delta * coef_vel_reduc)
	local_up_speed = lerp(
			_input_up_speed * up_speed_multi, local_up_speed, delta * coef_vel_reduc)

	## rotations
	_rotation_helper.rotate_y(-deg_to_rad(local_rotation.y))
	_camera.rotate_x(-deg_to_rad(local_rotation.x))
	_camera.rotation.x = clamp(
			_camera.rotation.x, deg_to_rad(-85), deg_to_rad(85)
	)
	_mapod.rotation.y = _rotation_helper.rotation.y
	_mapod_visitor.rotation.x = _camera.rotation.x
	_input_rotation_vector.x = local_rotation.y
	_input_rotation_vector.y = local_rotation.x
	
	## movements
	var forward_linear_speed = _mapod.transform.basis.z
	var right_linear_speed = forward_linear_speed.rotated(
			Vector3(0, 1, 0), deg_to_rad(90))
	forward_linear_speed = forward_linear_speed.normalized()
	right_linear_speed = right_linear_speed.normalized()
	velocity = forward_linear_speed * local_forward_speed 
	velocity += right_linear_speed * local_right_speed
	velocity += Vector3(0, 1, 0) * local_up_speed
	move_and_slide()
	_input_forward_speed = local_forward_speed
	_input_right_speed = local_right_speed
	_input_up_speed = local_up_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(delta):
	_handle_tick(delta)


func _unhandled_input(event):
	if input_disabled_flag == false:
		if event is InputEventKey:
			if event.is_action_pressed("mapod4d_rotate_right"):
				_keyboard_status.rotate_right = true
			elif event.is_action_released("mapod4d_rotate_right"):
				_keyboard_status.rotate_right = false

			if event.is_action_pressed("mapod4d_rotate_left"):
				_keyboard_status.rotate_left = true
			elif event.is_action_released("mapod4d_rotate_left"):
				_keyboard_status.rotate_left = false

			if event.is_action_pressed("mapod4d_rotate_up"):
				_keyboard_status.rotate_up = true
			elif event.is_action_released("mapod4d_rotate_up"):
				_keyboard_status.rotate_up = false

			if event.is_action_pressed("mapod4d_rotate_down"):
				_keyboard_status.rotate_down = true
			elif event.is_action_released("mapod4d_rotate_down"):
				_keyboard_status.rotate_down = false

			if event.is_action_pressed("mapod4d_forward"):
				_keyboard_status.forward = true
			elif event.is_action_released("mapod4d_forward"):
				_keyboard_status.forward = false

			if event.is_action_pressed("mapod4d_backward"):
				_keyboard_status.backward = true
			elif event.is_action_released("mapod4d_backward"):
				_keyboard_status.backward = false

			if event.is_action_pressed("mapod4d_left"):
				_keyboard_status.left = true
			elif event.is_action_released("mapod4d_left"):
				_keyboard_status.left = false

			if event.is_action_pressed("mapod4d_right"):
				_keyboard_status.right = true
			elif event.is_action_released("mapod4d_right"):
				_keyboard_status.right = false

			if event.is_action_pressed("mapod4d_up"):
				_keyboard_status.up = true
			elif event.is_action_released("mapod4d_up"):
				_keyboard_status.up = false

			if event.is_action_pressed("mapod4d_down"):
				_keyboard_status.down = true
			elif event.is_action_released("mapod4d_down"):
				_keyboard_status.down = false

		elif event is InputEventMouseMotion:
			_input_rotation_vector = event.relative
#			print(str(event))

		elif event is InputEventJoypadMotion:
#			print(str(event))
			if event.axis == 1:
				pass

		elif event is InputEventJoypadButton:
			pass

func _elab_keyboard():
	if _keyboard_status.rotate_right == true:
		_input_rotation_vector = Vector2(1, 0)
	if _keyboard_status.rotate_left == true:
		_input_rotation_vector = Vector2(-1, 0)
	if _keyboard_status.rotate_up == true:
		_input_rotation_vector = Vector2(0, 1)
	if _keyboard_status.rotate_down == true:
		_input_rotation_vector = Vector2(0, -1)
	if _keyboard_status.forward == true:
		_input_forward_speed = -1
	if _keyboard_status.backward == true:
		_input_forward_speed = 1
	if _keyboard_status.right == true:
		_input_right_speed = 1
	if _keyboard_status.left == true:
		_input_right_speed = -1
	if _keyboard_status.up == true:
		_input_up_speed = 1
	if _keyboard_status.down == true:
		_input_up_speed = -1


func _elab_joypad():
	pass


# ----- public methods

# ----- private methods





