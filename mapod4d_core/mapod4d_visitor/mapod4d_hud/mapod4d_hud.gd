# tool
@tool

# class_name

# extends
extends Control

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

# ----- public variables

# ----- private variables
@onready var _interactionE = %InteractionE
@onready var _interactionR = %InteractionR
@onready var _speed = %SpeedData
@onready var _altitude = %AltitudeData
@onready var _status = %Status

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.

# ----- public methods

func enable_int_e():
	_interactionE.visible = true


func disable_int_e():
	_interactionE.visible = false


func enable_int_r():
	_interactionR.visible = true


func disable_int_r():
	_interactionR.visible = false


func set_speed(value):
	_speed.text = str(value)


func set_altitude(value):
	_altitude.text = str(value) + "m"


func set_status(value):
	_status.text = str(value)


func disable_debug():
	$GridContainer/DebugLeft.visible = false
	$GridContainer/DebugRight.visible = false

# ----- private methods
