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

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

# ----- public methods

func enableIntE():
	_interactionE.visible = true


func disableIntE():
	_interactionE.visible = false


func enableIntR():
	_interactionR.visible = true


func disableIntR():
	_interactionR.visible = false

# ----- private methods
