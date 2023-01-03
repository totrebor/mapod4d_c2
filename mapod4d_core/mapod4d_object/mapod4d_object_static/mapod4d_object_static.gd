# tool
@tool

# class_name
class_name Mapod4dObjectStatic

# extends
extends StaticBody3D

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
@export_multiline var information: String = ""

# ----- public variables
var internal_object := Mapod4dObject.new()

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	if internal_object != null:
		internal_object.information = information

# ----- remaining built-in virtual methods

# ----- public methods

func get_object():
	return internal_object


func interaction_e():
	pass


func interaction_r():
	pass

# ----- private methods





