# tool

# class_name
class_name Mapod4dUtils

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
enum MAPOD4D_METAVERSE_LOCATION {
	DEV = 0,
	LOCAL,
}

# ----- constants
const MAPOD4D_METAVERSE_EXT = "ma4d"
const TEMPL_DIR = "res://mapod4d_templates/"
const TEMPL_METAVERESE = "mapod_4d_templ_metaverse.tscn"

# ----- exported variables

# ----- public variables

# ----- private variables
var _current_location = ""
var _metaverse_list = []

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ----- remaining built-in virtual methods

# ----- public methods

## load metaverses list
func metaverse_list_load(location: MAPOD4D_METAVERSE_LOCATION):
	var dir = null
	if _choose_metaverse_location(location) == true:
		dir = DirAccess.open(_current_location)

	if dir != null:
		var list_dir = dir.get_directories()
		for directory_name in list_dir:
			if dir.file_exists(_current_location + "/" + 
					directory_name + "/" + directory_name + ".ma4d"):
				_metaverse_list.push_front(directory_name)
#		## dir exists
#		var list_files = dir.get_files()
#		for file_name in list_files:
#			if file_name.ends_with("." + MAPOD4D_METAVERSE_EXT):
#				var file = FileAccess.open(
#					current_location + "/" + file_name, FileAccess.READ)
#				if file != null:
#					_json_check(file)
#					file = null
#				else:
#					print("FILEERROR")
	else:
		printerr("%s" % str(DirAccess.get_open_error()))


func metaverse_list_to_item_list(destination: ItemList):
	for element in _metaverse_list:
		destination.add_item(element)


func metaverse_list_clear():
	_metaverse_list.clear()


func metaverse_scaffold(
		location: MAPOD4D_METAVERSE_LOCATION,
		metaverse_id: String,
		v1: int, v2: int, v3: int, v4: int):
	var ret_val = {
		"response": false,
		"scenes_list": []
	}
	var dir = null
	if _choose_metaverse_location(location) == true:
		dir = DirAccess.open(_current_location)

	if dir != null:
		var metaverse_path = _current_location + "/" + metaverse_id
		var metaverse_data = metaverse_path + "/" + metaverse_id + ".ma4d"
		var metaverse_assets = metaverse_path + "/" + "assets"
		var metaverse_tamt = metaverse_path + "/" + "tamt"
		if dir.dir_exists(metaverse_path) == false:
			if dir.make_dir(metaverse_path) == OK:
				var file = FileAccess.open(metaverse_data, FileAccess.WRITE)
				var metaverse_info = {
							"name": metaverse_id,
							"v1":  v1,
							"v2":  v2,
							"v3":  v3,
							"v4":  v4,
						}
				print(metaverse_info)
				metaverse_info.name = str(metaverse_id)
				var metaverse_info_json = JSON.stringify(metaverse_info)
				file.store_line(metaverse_info_json)
				file = null
			dir.make_dir(metaverse_assets)
			dir.make_dir(metaverse_tamt)
			var metaverse_name = metaverse_id.substr(0,1).to_upper()
			metaverse_name += metaverse_id.substr(1)
			if _save_templ_scene(
					TEMPL_METAVERESE,
					metaverse_path + "/" + metaverse_id + ".tscn", 
					metaverse_name):
				ret_val.scenes_list.push_front(metaverse_path)
			ret_val.response = true
		else:
			printerr("Metaverse directory already exists")
	return ret_val


func metaverse_info_read(source_file):
	var ret_val = false
	var resource = Mapod4dMa4dRes.new()
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file != null:
		var data = file.get_line()
		var data_json = JSON.parse_string(data)
		if data_json != null:
			resource.name = str(data_json.name)
			resource.v1 = data_json.v1
			resource.v2 = data_json.v2
			resource.v3 = data_json.v3
			resource.v4 = data_json.v4
	return [ret_val, resource]


func planet_scaffold(
		location: MAPOD4D_METAVERSE_LOCATION,
		metaverse_id: String,
		planet_id,
		planet_type: Mapod4dPlanet.MAPOD4D_PLANET_TYPE):
	pass

# ----- private methods

func _choose_metaverse_location(location: MAPOD4D_METAVERSE_LOCATION):
	var ret_val = true
	_current_location = ""
	match location:
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.LOCAL:
			_current_location = "res://mapod4d_multiverse_local"
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.DEV:
			_current_location = "res://mapod4d_multiverse_dev"
		_:
			printerr("invalid metaverse location")
			ret_val = false
	return ret_val


## load packed template scene
## change root node name
## save new packed scene
func _save_templ_scene(
		source_name: String, dest_path: String, root_node_name: String):
	var ret_val = false
	if ResourceLoader.exists(TEMPL_DIR + source_name, "PackedScene"):
		print("1")
		var lscene: PackedScene = load(TEMPL_DIR + source_name)
		print("2")
		var node : Node = lscene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		print("3")
		node.set_name(root_node_name)
		print("4")
		var scene: PackedScene = PackedScene.new()
		print("5")
		scene.pack(node)
		print("6")
		var error = ResourceSaver.save(scene, dest_path)
		print(dest_path + " 7")
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
		else:
			ret_val = true
	else:
		printerr(TEMPL_DIR + source_name + " not found")
	return ret_val


## check json file
func _json_check(file):
	return true
#	const RVER = "(?<digit0>[0-9]+)\\.(?<digit1>[0-9]+)\\.(?<digit2>[0-9]+)\\.(?<digit3>[0-9]+)"
#	var regex = RegEx.new()
#	regex.compile(RVER)
#	## file exists
#	var json = JSON.new()
#	if json.parse(file.get_as_text()) == OK:
#		## json ok
#		print(str(json.data))
#		var version = regex.search(json.data.version)
#		if version != null:
#			## version ok
#			var data = {}
#			data["metaversefile"] = json.data.filename + \
#					"." + json.data.extension
#			data["core"] = version.get_string("digit0")
#			data["ver"] = version.get_string("digit1")
#			data["build"] = version.get_string("digit2")
#			data["subbuild"] = version.get_string("digit3")
#			var metaverse_file_exists = FileAccess.file_exists(
#					"users://metaverse" + "/" + data["metaversefile"])
#			if metaverse_file_exists == true:
#				print("OK")
#				_metaverse_files.push_back(data)
#			else:
#				print("METAVERSEERROR")
#		else:
#			print("VERSIONERROR")
#	else:
#		print("PARSEERROR")
