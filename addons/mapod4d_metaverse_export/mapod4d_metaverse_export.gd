@tool
extends EditorPlugin

var export_plugin


func _enter_tree():
	export_plugin = preload("mapod4d_metaverse_export_core.gd").new()
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null
