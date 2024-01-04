# tool

# class_name
class_name Mapod4dBaseUi

# extends
extends Control

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals
## request scene whithout progressbar
signal m4d_scene_npb_requested(scene_name: String, fullscreen_flag: bool)
## request scene whith progressbar
signal m4d_scene_requested(scene_name: String, fullscreen_flag: bool)
## request metaverse whith progressbar
signal m4d_metaverse_requested(
		location :Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION, 
		metaverse_id :String, fullscreen_flag:bool)
## request planet whith progressbar
signal m4d_planet_requested(
		metaverse_res_path: String, planet_id: String, fullscreen_flag: bool)

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

# ----- private methods





