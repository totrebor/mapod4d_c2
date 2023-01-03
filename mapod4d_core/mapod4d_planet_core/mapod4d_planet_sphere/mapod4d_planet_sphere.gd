# tool

# class_name
class_name Mapod4dPlanetSphere

# extends
extends Node3D

## Base class for metaverse 3d
##
## Spherical metaverse.
##


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
var core: Mapod4dPlanetCore
var metaverse = null

# ----- private variables

# ----- onready variables

# ----- exported variables

# ----- public variables

# ----- private variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	core = Mapod4dPlanetCore.new()
	core.setPlanetType(Mapod4dPlanetCoreRes.MAPOD4D_PLANET_TYPE.MPT_SPHERE)

# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.

# ----- public methods

# ----- private methods

