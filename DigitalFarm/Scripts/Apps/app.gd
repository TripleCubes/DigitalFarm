class_name App
extends Node2D

@onready var _main_window_wrapper_list: Node2D = get_node("/root/Main/WindowWrapperList")

var _window_wrapper_scene: PackedScene

var window_wrapper_list: = []

func run_app() -> void:
	var window_wrapper: = _window_wrapper_scene.instantiate()
	window_wrapper.app = self
	window_wrapper_list.append(window_wrapper)
	
	_main_window_wrapper_list.add_child(window_wrapper)
