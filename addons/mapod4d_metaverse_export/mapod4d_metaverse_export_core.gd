@tool
extends EditorExportPlugin




func _begin_customize_resources(platform, features):
	print("_begin_customize_resources")
	print(platform)
	print(features)
	return false


func _begin_customize_scenes(platform, features):
	print("_begin_customize_scenes")
	print(platform)
	print(features)
	return false


func _customize_resource(resource, path):
	print("_customize_resource")
	print(resource)
	print(path)
	return null


func _customize_scene(scene, path):
	print("_customize_scene")
	print(scene)
	print(path)
	return null


func _get_name():
	return "mapod4d.export_metaverse"


func _export_file(path, type, features):
	print(path)
