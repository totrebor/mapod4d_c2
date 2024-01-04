# tool

# class_name

# extends
extends Node
## Root object of multiverse.
##
## This object support autoload of general scenes and metaverses.
##


# ----- signals

# ----- enums
enum MAPOD4D_RUN_STATUS {
	F6 = 0,
	STANDARD
}

# ----- constants
const MAPOD4D_MAIN_RES = "res://mapod4d_core/mapod4d_main/mapod4d_main.tscn"
const MAPOD4D_VISITOR = "res://mapod4d_core/mapod4d_visitor/mapod4d_visitor.tscn"
const MAPOD4D_START = "res://mapod4d_core/mapod4d_start/mapod4d_start.tscn"
const MAPOD4D_ROOT = "/root/Mapod4dMain"
const MAPOD4D_LOADED_SCENE_NODE_TAG = "LoadedScene"
const EDITOR_DBG_BASE_PATH = "res://test"

const M4DVERSION = {
	'v1': 2, 
	'v2': 0,
	'v3': 0,
	'v4': 1,
	'p': "a",
	'godot': {
		'v1': 4,
		'v2': 2,
		'v3': 1,
		'v4': 2, # dev = 0, rc = 1, stable = 2
		'p': "stable"
	}
}
const M4DNAME = "core"

# default 0 version of M4D
const M4D0VERSION = {
	'v1': 0, 
	'v2': 0,
	'v3': 0,
	'v4': 0,
	'p': "a",
	'godot': {
		'v1': 4,
		'v2': 2,
		'v3': 1,
		'v4': 2, # dev = 0, rc = 1, stable = 2
		'p': "stable"
	}
}


## global constant
const OSWEBNAME = "web"


# ----- exported variables

# ----- public variables
var mapod4d_debug = true
var _prog_debug = 0
var utils = Mapod4dUtils.new()

# ----- private variables
var _current_loaded_scene = null
var _loading_scene_res_path = ""
var _mapod4d_run_status = MAPOD4D_RUN_STATUS.STANDARD
var _progress = [ 0.0 ]

var _current_metaverse_location = utils.MAPOD4D_METAVERSE_LOCATION.M4D_LOCAL
var _current_metaverse_path = ""
var _current_metaverse_res_path = ""
var _current_planet_name = ""

# ----- onready variables
@onready var _mapod4d_main_res = preload(MAPOD4D_MAIN_RES)
@onready var _mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
@onready var _start_scene_res = preload(MAPOD4D_START)
@onready var _mapod4d_visitor_res = preload(MAPOD4D_VISITOR)


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	var args = OS.get_cmdline_user_args()
	# standard parameter
	if "-m4dver" in args:
		if utils != null:
			utils.free()
		# BUG Leaked instance: SceneTreeTimer
		get_tree().quit()
	# prevent manually run
	if "-m4drun" not in args: 
		_write_version(false)
		if utils != null:
			utils.free()
		# BUG Leaked instance: SceneTreeTimer
		get_tree().quit()
	if OS.get_name() != OSWEBNAME:
		if "-m4d0ver" not in args:
			_write_version(false)
		else:
			_write_version(true)
	if _mapod4d_main == null:
		## support for F6 in edit mode when MopodMain is Null (not main scene)
		## force not show intro
		_mapod4d_run_status = MAPOD4D_RUN_STATUS.F6
		_f6_start()
	else:
		## support for F5 in run mode MopodMain is main scene
		_mapod4d_run_status = MAPOD4D_RUN_STATUS.STANDARD
		_standard_start()


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _loading_scene_res_path != "":
		var status = ResourceLoader.load_threaded_get_status(
				_loading_scene_res_path, _progress)
		var perc = _progress[0] * 100.0
#		print_debug("status " + str(status))
		match(status):
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
#				print_debug("progress " +  str(perc))
				_set_loading_progress_bar(perc)
			ResourceLoader.THREAD_LOAD_LOADED:
				print("progress " +  str(perc))
				_set_loading_progress_bar(perc)
#				print_debug("loaded") ## scene is loaded
				set_process(false)
				call_deferred("_load_scene_ended")
			ResourceLoader.THREAD_LOAD_FAILED:
#				print_debug("loading failed")
				set_process(false)
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
#				print_debug("loading invalid")
				set_process(false)
			_:
#				print_debug("loading status unkwonwn")
				set_process(false)
	else:
		set_process(false)


# ----- public methods

func im_alive():
	mapod4d_print("IMA")


func mapod4d_print(value):
	if mapod4d_debug == true:
		_prog_debug += 1
		if _prog_debug > 99:
			_prog_debug = 0
		print(str(_prog_debug) + " " + str(value))
		print(str(_prog_debug) + " " + str(get_stack()))


## return current metaverse location
func current_metaverse_location():
	return _current_metaverse_location


# ----- private methods
## write json version file
func _write_version(default_version):
		var json_data
		if default_version == true:
			json_data = JSON.stringify(M4D0VERSION)
		else:
			json_data = JSON.stringify(M4DVERSION)
		var base_dir = OS.get_executable_path().get_base_dir()
		if OS.has_feature('editor'):
			base_dir = EDITOR_DBG_BASE_PATH
		var file_name = base_dir + "/" + M4DNAME + ".json"
		var file = FileAccess.open(file_name, FileAccess.WRITE)
		if file != null:
			file.store_string(json_data)
			file.flush()

## load Mapod4dMain and return the instance
## F6 operation
func _f6_loadMain():
	var local_current_scene = get_tree().current_scene
	if not (local_current_scene is Mapod4dMain):
		var root = get_node("/root")
		if _mapod4d_main_res != null:
			_mapod4d_main = _mapod4d_main_res.instantiate()
			root.remove_child(local_current_scene)
			root.add_child(_mapod4d_main)
			_mapod4d_main.owner = root
	else:
		local_current_scene = null
	return local_current_scene


## add scene to mapod4d_main
## _current_loaded_scene updated
func _f6_add_scene_to_main(scene):
	var ret_val = false
	var loaded_scene_placeholder = _mapod4d_main.get_node(
			MAPOD4D_LOADED_SCENE_NODE_TAG)
	## add new loaded scene
	if scene.get_parent():
		scene.get_parent().remove_child(scene)
	loaded_scene_placeholder.add_child(scene)
	scene.set_owner(get_node("/root"))
	## new current scene
	_current_loaded_scene = scene
	ret_val = true
	return ret_val


## called only on F6
func _f6_start():
	_current_loaded_scene = null
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var local_current_scene = _f6_loadMain()
	if local_current_scene != null:
		if _f6_add_scene_to_main(local_current_scene) == true:
			_attach_current_loaded_scene_signals()
	else:
		pass # error load main


## called only on start F5 (standard run)
func _standard_start():
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	_current_loaded_scene = _start_scene_res.instantiate()
	var screen_size = DisplayServer.screen_get_size()
	@warning_ignore("integer_division")
	var x_position = floor(screen_size.x / 2) - floor(1024 / 2)
	@warning_ignore("integer_division")
	var y_position = floor(screen_size.y / 2) - floor(768 / 2)
	if x_position < 0:
		x_position = 0
	if y_position < 0:
		y_position = 0
	_current_loaded_scene.set_position(Vector2i(x_position, y_position))
	_attach_current_loaded_scene_signals()
	var placeholder = _mapod4d_main.get_node(MAPOD4D_LOADED_SCENE_NODE_TAG)
	placeholder.add_child(_current_loaded_scene)
	#_current_loaded_scene.owner = _mapod4d_main
	_current_loaded_scene.set_owner(get_node("/root"))


## load scene without progressbar and update
## _current_loaded_scene updated
func _load_npb_scene(scene_path):
	var ret_val = false
	if ResourceLoader.exists(scene_path):
		var scene_res = load(scene_path)
		if scene_res != null:
			var scene = scene_res.instantiate()
			if scene != null:
				var placeholder = _mapod4d_main.get_node(
						MAPOD4D_LOADED_SCENE_NODE_TAG)
				if placeholder.get_child_count() > 0:
					var children = placeholder.get_children()
					for child in children:
						placeholder.remove_child(child)
						child.queue_free()
				## new current scene
				_current_loaded_scene = scene
				_add_mapod()
				## add new loaded scene
				if _current_loaded_scene.get_parent():
					_current_loaded_scene.get_parent().remove_child(
						_current_loaded_scene)
				placeholder.add_child(_current_loaded_scene)
				#_current_loaded_scene.set_owner(_mapod4d_main)
				_current_loaded_scene.set_owner(placeholder)
				_attach_current_loaded_scene_signals()
				ret_val = true
	return ret_val


## starting progressbar
func _start_loading_progress_bar():
	var ret_val = null
	_mapod4d_main.init_progress_bar()
	if _loading_scene_res_path != null:
		var error = ResourceLoader.load_threaded_request(
				_loading_scene_res_path)
		print(ResourceLoader.load_threaded_get_status(_loading_scene_res_path))
		if error == OK:
			set_process(true)
			ret_val = true
	return ret_val


## process progressbar
func _set_loading_progress_bar(value: float):
	_mapod4d_main.set_progress_bar(value)


## end progressbar
func _end_loading_progress_bar():
	_mapod4d_main.end_progress_bar()


## call to start load scene with progressbar and update
func _start_load_scene(scene_res_path):
	if ResourceLoader.exists(scene_res_path):
		_loading_scene_res_path = scene_res_path
		if _start_loading_progress_bar() == false:
			printerr("ERROR _start_load_scene " + scene_res_path)


## called from _process
## load scene ended, _current_loaded_scene updated
func _load_scene_ended():
	var scene_res = ResourceLoader.load_threaded_get(_loading_scene_res_path)
	_loading_scene_res_path = ""
	if scene_res != null:
		await get_tree().create_timer(1).timeout
		var scene_instance = scene_res.instantiate()
		var placeholder = _mapod4d_main.get_node(MAPOD4D_LOADED_SCENE_NODE_TAG)
		if placeholder.get_child_count() > 0:
			var children = placeholder.get_children()
			for child in children:
				child.queue_free()
		## new current scene
		_current_loaded_scene = scene_instance
		_add_mapod()
		## add new loaded scene
		if _current_loaded_scene.get_parent():
			_current_loaded_scene.get_parent().remove_child(
					_current_loaded_scene)
		placeholder.add_child(_current_loaded_scene)
		_current_loaded_scene.set_owner(get_node("/root"))
		_attach_current_loaded_scene_signals()
	_end_loading_progress_bar()


## load scene no progress bar and update
## _current_loaded_scene updated
func _attach_current_loaded_scene_signals():
	mapod4d_print("_attach_current_loaded_scene_signals()")
	if _current_loaded_scene is Mapod4dBaseUi:
		mapod4d_print("_current_loaded_scene is Mapod4dBaseUi")
#		_current_loaded_scene.m4d_scene_requested.connect(
	#			_on_m4d_scene_requested)
#		_current_loaded_scene.m4d_scene_npb_requested.connect(
#				_on_m4d_scene_npb_requested)
		_current_loaded_scene.m4d_scene_requested.connect(
				_on_m4d_scene_requested, CONNECT_DEFERRED)
		_current_loaded_scene.m4d_scene_npb_requested.connect(
				_on_m4d_scene_npb_requested, CONNECT_DEFERRED)
		_current_loaded_scene.m4d_metaverse_requested.connect(
				_on_m4d_metaverse_requested, CONNECT_DEFERRED)
		_current_loaded_scene.m4d_planet_requested.connect(
				_on_m4d_planet_requested, CONNECT_DEFERRED)


# add mapod (visitor)
func _add_mapod():
	if (_current_loaded_scene is Mapod4dBaseMetaverse) or \
	(_current_loaded_scene is Mapod4dPlanetSphere):
		mapod4d_print("_current_loaded_scene is Mapod4dBaseMetaverse")
		var place_holder = _current_loaded_scene.get_node_or_null("MapodArea")
		if place_holder != null:
			var mapod = _mapod4d_visitor_res.instantiate()
			mapod.set_position(Vector3(0, 0, 10))
			mapod.current_camera_flag = true
			mapod.input_disabled_flag = false
			place_holder.add_child(mapod)
			mapod.set_owner(place_holder)
			## connects signals
			mapod.m4d_scene_requested.connect(
					_on_m4d_scene_requested, CONNECT_DEFERRED)
			mapod.m4d_scene_npb_requested.connect(
					_on_m4d_scene_npb_requested, CONNECT_DEFERRED)
			mapod.m4d_metaverse_requested.connect(
					_on_m4d_metaverse_requested, CONNECT_DEFERRED)
			mapod.m4d_planet_requested.connect(
					_on_m4d_planet_requested, CONNECT_DEFERRED)


## elaborates signal load new scene 
## without the progressbar and the fullscreen flag
func _on_m4d_scene_npb_requested(scene_res_path, fullscreen_flag):
	mapod4d_print("_on_scene_npd_requested " + \
			scene_res_path + " " + str(fullscreen_flag))
	if ResourceLoader.exists(scene_res_path):
		_current_metaverse_res_path = ""
		_current_planet_name = ""
		if _mapod4d_run_status == MAPOD4D_RUN_STATUS.F6:
			pass
		else:
			_current_loaded_scene.queue_free()
			if fullscreen_flag == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			# load scene
			if _load_npb_scene(scene_res_path) == true:
				_attach_current_loaded_scene_signals()
	else:
		mapod4d_print("not found " + scene_res_path)


## elaborates signal load new scene 
## with the progressbar and the fullscreen flag
func _on_m4d_scene_requested(scene_res_path, fullscreen_flag):
	mapod4d_print("_on_scene_requested " + \
			scene_res_path + " " + str(fullscreen_flag))
	if ResourceLoader.exists(scene_res_path):
		_current_metaverse_res_path = ""
		_current_planet_name = ""
		if _mapod4d_run_status == MAPOD4D_RUN_STATUS.F6:
			mapod4d_print("_on_scene_requested F6")
		else:
			_current_loaded_scene.queue_free()
			if fullscreen_flag == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			# load scene deferred
			mapod4d_print("_on_scene_requested start load")
			_start_load_scene(scene_res_path)
	else:
		mapod4d_print("not found " + scene_res_path)


## elaborates signal load new metaverse 
## with the progressbar and the fullscreen flag
func _on_m4d_metaverse_requested(
		location, metaverse_id, fullscreen_flag):
	var metaverse_res_path = utils.get_metaverse_res_path(
			location, metaverse_id)

	if location == utils.MAPOD4D_METAVERSE_LOCATION.M4D_PCK:
		utils.load_metaverse_pck(location, metaverse_id)
	if ResourceLoader.exists(metaverse_res_path):
		_current_metaverse_location = location
		_current_metaverse_res_path = metaverse_res_path
		_current_planet_name = ""
		mapod4d_print(_current_metaverse_res_path.get_base_dir())
		if _mapod4d_run_status == MAPOD4D_RUN_STATUS.F6:
			pass
		else:
			_current_loaded_scene.queue_free()
			if fullscreen_flag == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			# load scene deferred
			_start_load_scene(metaverse_res_path)
	else:
		mapod4d_print("not found " + metaverse_res_path)


## elaborates signal load new metaverse 
## with the progressbar and the fullscreen flag
func _on_m4d_planet_requested(
		metaverse_res_path: String, planet_id: String, fullscreen_flag):
	var planet_res_path = utils.get_planet_res_path(
		metaverse_res_path, planet_id
	)
	if ResourceLoader.exists(planet_res_path):
		_current_metaverse_res_path = metaverse_res_path
		_current_planet_name = planet_id
		if _mapod4d_run_status == MAPOD4D_RUN_STATUS.F6:
			pass
		else:
			_current_loaded_scene.queue_free()
			if fullscreen_flag == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			_start_load_scene(planet_res_path)
	else:
		mapod4d_print("not found " + planet_res_path)

