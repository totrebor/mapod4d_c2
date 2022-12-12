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

# ----- constants
const MAPOD4D_MAIN_RES = "res://mapod4d_core/mapod4d_main/mapod4d_main.tscn"
const MAPOD4D_VISITOR = "res://mapod4d_core/mapod4d_visitor/mapod4d_visitor.tscn"
const MAPOD4D_START = "res://mapod4d_core/mapod4d_start/mapod4d_start.tscn"
const MAPOD4D_ROOT = "/root/Mapod4dMain"
const MAPOD4D_LOADED_SCENE_NODE_TAG = "LoadedScene"


# ----- exported variables

# ----- public variables

# ----- private variables
var _current_loaded_scene = null
<<<<<<< HEAD
var _loading_scene_res_path = ""
var _mapod4d_run_status = MAPOD4D_RUN_STATUS.STANDARD
var _progress = [ 0.0 ]

# ----- onready variables
@onready var _mapod4d_main_res = preload(MAPOD4D_MAIN_RES)
@onready var _mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
@onready var _start_scene_res = preload(MAPOD4D_START)
@onready var _mapod4d_visitor_res = preload(MAPOD4D_VISITOR)

=======
var _loading_scene_res = ""
var _resource_loaded = false


# ----- onready variables
@onready var mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
@onready var mapod4d_intro  = true
>>>>>>> parent of fe2b88d (new scene load in mapod4d_autoload)

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	if mapod4d_main == null:
		## support for F6 in edit mode when MopodMain is Null (not main scene)
		## force not show intro
		_start_f6()
	else:
		## support for F5 in run mode MopodMain is main scene
		_mapod4d_start()


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _loading_scene_res != "":
		if _resource_loaded == false:
			var progress = []
			var status = ResourceLoader.load_threaded_get_status(
					_loading_scene_res, progress)
			var perc = progress[0] * 100 * 1.0
			_set_progress_bar(perc)
			print("progress " + str(perc))
			if status == ResourceLoader.THREAD_LOAD_LOADED:
				print("loaded") ## scene is loaded
				_resource_loaded = true
				set_process(false)
				call_deferred("_load_scene")
	else:
		_loading_scene_res = ""
		## progressbar = 0
		set_process(false)


# ----- public methods


func im_alive():
	print("IMA")




# ----- private methods

## load Mapod4dMain and return the instance
func _loadMain():
	var local_current_scene = get_tree().current_scene
	if not (local_current_scene is Mapod4dMain):
		var root = get_node("/root")
		var mapod4d_main_res = preload(MAPOD4D_MAIN_RES)
		if mapod4d_main_res != null:
			mapod4d_main = mapod4d_main_res.instantiate()
			root.remove_child(local_current_scene)
			root.add_child(mapod4d_main)
			mapod4d_main.owner = root
	else:
		local_current_scene = null
	return local_current_scene


<<<<<<< HEAD
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
=======
func _init_progress_bar():
	mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
	if mapod4d_main != null:
		mapod4d_main.init_progress_bar()
>>>>>>> parent of fe2b88d (new scene load in mapod4d_autoload)


func _set_progress_bar(value: float):
	mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
	if mapod4d_main != null:
		mapod4d_main.set_progress_bar(value)


<<<<<<< HEAD
## called only on start F5 (standard run)
func _standard_start():
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	_current_loaded_scene = _start_scene_res.instantiate()
	var screen_size = DisplayServer.screen_get_size()
	@warning_ignore(integer_division)
	var x_position = floor(screen_size.x / 2) - floor(1024 / 2)
	@warning_ignore(integer_division)
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
=======
func _end_progress_bar():
	mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
	if mapod4d_main != null:
		mapod4d_main.end_progress_bar()
>>>>>>> parent of fe2b88d (new scene load in mapod4d_autoload)


## load scene without progressbar and update
## _current_loaded_scene updated
func _load_npb_scene(scene):
	var ret_val = false
<<<<<<< HEAD
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
			_current_loaded_scene.set_owner(get_node("/root"))
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
func _start_load_scene(scene_path):
	_loading_scene_res_path = scene_path
	if _start_loading_progress_bar() == false:
		print("ERROR _start_load_scene " + scene_path)


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
		placeholder.add_child(scene_instance)
		_current_loaded_scene.set_owner(get_node("/root"))
		_attach_current_loaded_scene_signals()
	_end_loading_progress_bar()
=======
	mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
	if mapod4d_main != null:
		print("mapod4d_main != null")
		var loaded_scene_placeholder = mapod4d_main.get_node(
				MAPOD4D_LOADED_SCENE_NODE_TAG)
		if loaded_scene_placeholder.get_child_count() > 0:
			var children = loaded_scene_placeholder.get_children()
			for child in children:
				child.queue_free()
		## add new loaded scene
		loaded_scene_placeholder.add_child(scene)
#		scene.owner = loaded_scene_placeholder
		scene.set_owner(mapod4d_main)
		## new current scene
		_current_loaded_scene = scene
		ret_val = true
	return ret_val
>>>>>>> parent of fe2b88d (new scene load in mapod4d_autoload)


## load scene with progressbar and update
## _current_loaded_scene updated
func _load_scene():
	var ret_val = false
	print("_load_scene()")
	var scene_res = ResourceLoader.load_threaded_get(_loading_scene_res)
	_loading_scene_res = ""
	if scene_res != null:
		var scene_instance = scene_res.instantiate()
		mapod4d_main = get_node_or_null(MAPOD4D_ROOT)
		if mapod4d_main != null:
			var loaded_scene_placeholder = mapod4d_main.get_node(
					MAPOD4D_LOADED_SCENE_NODE_TAG)
			if loaded_scene_placeholder.get_child_count() > 0:
				var children = loaded_scene_placeholder.get_children()
				for child in children:
					child.queue_free()
			## add new loaded scene
			loaded_scene_placeholder.add_child(scene_instance)
			scene_instance.owner = mapod4d_main
			## new current scene
			_current_loaded_scene = scene_instance
			ret_val = true
	_end_progress_bar()
	return ret_val

## load scene no progress bar and update
## _current_loaded_scene updated
func _attach_current_loaded_scene_signals():
	print("_attach_current_loaded_scene_signals()")
	if _current_loaded_scene is Mapod4dBaseUi:
		print("_current_loaded_scene is Mapod4dBaseUi")
#		_current_loaded_scene.m4d_scene_requested.connect(
#			_on_m4d_scene_requested)
#		_current_loaded_scene.m4d_scene_npb_requested.connect(
#			_on_m4d_scene_npb_requested)
		_current_loaded_scene.m4d_scene_requested.connect(
			_on_m4d_scene_requested, CONNECT_DEFERRED)
		_current_loaded_scene.m4d_scene_npb_requested.connect(
			_on_m4d_scene_npb_requested, CONNECT_DEFERRED)

func _add_mapod():
	print("_add_mapod()")
	
	if _current_loaded_scene is Mapod4dBaseMetaverse:
		print("_current_loaded_scene is Mapod4dBaseMetaverse")
		var place_holder = _current_loaded_scene.get_node_or_null("MapodArea")
#		if place_holder != null:
#			var mapod = _mapod4d_visitor_res.instantiate()
#			mapod.set_position(Vector3(-10, 5, 5))
#			place_holder.add_child(mapod)
#			mapod.owner = get_node("/root")

	elif _current_loaded_scene is Mapod4dSpherePlanet:
		print("_current_loaded_scene is Mapod4dSpherePlanet")


## called only on F6
func _start_f6():
	_current_loaded_scene = null
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var local_current_scene = _loadMain()
	if local_current_scene != null:
		if _load_npb_scene(local_current_scene) == true:
			pass # no error load scene
	else:
		pass # error load main


## called only on start F5
func _mapod4d_start():
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var start_scene_res = preload(MAPOD4D_START)
	var start_scene_instance = start_scene_res.instantiate()
	var screen_size = DisplayServer.screen_get_size()
	@warning_ignore(integer_division)
	var x_position = floor(screen_size.x / 2) - floor(1024 / 2)
	@warning_ignore(integer_division)
	var y_position = floor(screen_size.y / 2) - floor(768 / 2)
	if x_position < 0:
		x_position = 0
	if y_position < 0:
		y_position = 0
	start_scene_instance.set_position(Vector2i(x_position, y_position))
	if _load_npb_scene(start_scene_instance) == true:
		_attach_current_loaded_scene_signals()


## elaborates signal load new scene 
## without thr progressbar and the fullscreen flag
func _on_m4d_scene_npb_requested(scene_name, fullscreen_flag):
	print("_on_scene_npd_requested " + scene_name + " " + str(fullscreen_flag))
	_current_loaded_scene.visible = false
	if fullscreen_flag == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# load scene
	var scene_res = load(scene_name)
	if scene_res != null:
		var scene = scene_res.instantiate()
		if scene != null:
			if _load_npb_scene(scene) == true:
				_attach_current_loaded_scene_signals()


## elaborates signal load new scene 
## with the progressbar and the fullscreen flag
func _on_m4d_scene_requested(scene_name, fullscreen_flag):
	print("_on_scene_requested " + scene_name + " " + str(fullscreen_flag))
	_current_loaded_scene.visible = false
	if fullscreen_flag == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_init_progress_bar()
	## start load scene
	_loading_scene_res = scene_name
	_resource_loaded = false
	var result = ResourceLoader.load_threaded_request(_loading_scene_res)
	if result != OK:
		print("ERRORLOADRESOURCE")
		_loading_scene_res = ""
	else:
		## progressbar = 0
		set_process(true)

