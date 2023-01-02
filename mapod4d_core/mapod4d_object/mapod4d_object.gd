# tool

# class_name
class_name Mapod4dObject

# extends
extends Node

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

# object description
var information: String = "object":
	get:
		return information
	set(value):
		if value == "":
			information = "object"
		else:
			information = value
# interaction type E
var intE := true
# interaction type R
var intR := false

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ssdasdwedewdwedwe")

# ----- remaining built-in virtual methods

# ----- public methods


# ----- private methods





