# tool

# class_name
class_name Mapod4dBaseMetaverse

# extends
extends Node3D


## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums

# ----- constants
#const planet_sphere_res = preload(
#	"res://mapod4d_core/mapod4d_planet_model/mapod4d_planet_model_sphere/" + \
#	"mapod4d_planet_model_sphere.tscn") 
const planet_sphere_res = preload(
		"res://mapod4d_core/mapod4d_object/mapod4d_object_static/" + \
		"mapod4d_os_planet_model_sphere/mapod4d_os_planet_model_sphere.tscn")
	
# ----- exported variables

# ----- public variables
var location = Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.M4D_DEV

# ----- private variables
var _list_of_planets = null
var _metaverse_id = null

# ----- onready variables
@onready var _utils = Mapod4dUtils.new()


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_metaverse_id = str(name).to_lower()
	var list_of_planets_path = _utils.get_metaverse_element_path(
			location, _metaverse_id, "list_of_planets.res"
	)
	_list_of_planets = load(list_of_planets_path)
	var placeolder = get_node_or_null("Planets")
	if placeolder != null:
		var x_pos = 0
		var z_pos = 0
		for planet_data in _list_of_planets.list:
			if planet_data is Mapod4dPlanetCoreRes:
				var planet = planet_sphere_res.instantiate()
				planet.set_name(planet_data.id)
				planet.set_position(Vector3(x_pos, 0, z_pos))
				z_pos = z_pos - (1.5 + (1 / (1 + x_pos)))
				x_pos = x_pos + 3
				placeolder.add_child(planet)
				planet.set_owner(placeolder)

# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.

# ----- public methods

# ----- private methods

