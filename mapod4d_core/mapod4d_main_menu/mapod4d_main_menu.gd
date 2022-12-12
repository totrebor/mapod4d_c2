# tool

# class_name

# extends
extends Mapod4dBaseUi

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
var _utils = Mapod4dUtils.new()
var _metaverse_info = {}

# ----- onready variables
@onready var _button_main_exit = %MainExit
@onready var _button_enter_into_metaverse = %EnterIntoMetaverse
@onready var _list_of_metaverses = %MetaversesList


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	_button_main_exit.pressed.connect(_on_button_main_exit_pressed)
	_button_enter_into_metaverse.pressed.connect(
			_button_enter_into_metaverse_pressed)
	_list_of_metaverses.item_selected.connect(
		_on_list_of_metaverses_selected)
	_utils.metaverse_main_menu_list_read(_list_of_metaverses)
	

# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.

# ----- public methods

# ----- private methods

func _on_list_of_metaverses_selected(metaverse_id):
	print("_on_list_of_metaverses_selected")
	_metaverse_info = _list_of_metaverses.get_item_metadata(metaverse_id)
	print(_metaverse_info.id)
	_button_enter_into_metaverse.disabled = false
	

func _button_enter_into_metaverse_pressed():
	print("_button_enter_into_metaverse_pressed")
	var scene_name = _utils.get_metaverse_scene_path(
			_metaverse_info.location, _metaverse_info.id)
	print(scene_name)
	emit_signal("m4d_scene_npb_requested", scene_name, true)


func _on_button_main_exit_pressed():
	get_tree().quit()





