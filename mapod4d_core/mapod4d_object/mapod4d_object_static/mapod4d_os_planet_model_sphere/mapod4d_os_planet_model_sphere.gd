# tool

# class_name

# extends
extends Mapod4dObjectStatic

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
func interaction_e():
	var metaverse_res_path = internal_object.metaverse_res_path
	var planet_id = internal_object.planet_id
	internal_object.request.type = Mapod4dObject.OBJREQ.TO_PLANET
	internal_object.request.arguments["metaverse_res_path"] = metaverse_res_path
	internal_object.request.arguments["planet_id"] = planet_id

# ----- private methods





