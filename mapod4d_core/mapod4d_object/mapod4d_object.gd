# tool

# class_name
class_name Mapod4dObject

# extends
extends Object

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums
enum OBJREQ {
	NONE = 0,
	TO_MAINMENU,
	TO_METAVERSE,
	TO_PLANET,
}

# ----- constants

# ----- exported variables

# ----- public variables

## object description
var information: String = "object":
	get:
		return information
	set(value):
		if value == "":
			information = "object"
		else:
			information = value
## interaction type E
var intE := true
## interaction type R
var intR := false
##
var request = {
	"type": OBJREQ.NONE,
	"arguments": {}
}
var metaverse_res_path := ""
var planet_id := ""

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

# ----- remaining built-in virtual methods

# ----- public methods

## reset the request
func reset_request():
	request.type = OBJREQ.NONE
	request.argument = {}

## check if request is correct
func request_check():
	var ret_val = false
	match(request.type):
		OBJREQ.NONE:
			ret_val = true
		OBJREQ.TO_MAINMENU:
			ret_val = true
		OBJREQ.TO_METAVERSE:
			if request.arguments.has("metaverse_res_path"):
				ret_val = true
		OBJREQ.TO_PLANET:
			if request.arguments.has("metaverse_res_path"):
				if request.arguments.has("planet_id"):
					ret_val = true
	return ret_val


# ----- private methods
