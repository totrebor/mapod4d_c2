# tool

# class_name
class_name Mapod4dPlanetCoreRes

# extends
extends Resource

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums
enum MAPOD4D_PLANET_TYPE {
	MPT_NONE=0,
	MPT_SPHERE,
	MPT_PLAIN,
}

# ----- constants

# ----- exported variables
@export var id: String = ""
@export var descr: String = ""
@export var planet_type: Mapod4dPlanetCoreRes.MAPOD4D_PLANET_TYPE \
		= MAPOD4D_PLANET_TYPE.MPT_NONE

# ----- public variables


# ----- private variables

# ----- onready variables

