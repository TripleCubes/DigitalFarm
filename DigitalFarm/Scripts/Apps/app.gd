class_name App
extends Node2D

@onready var _main_window_wrapper_list: Node2D = get_node("/root/Main/WindowWrapperList")

var _window_wrapper_scene: PackedScene

var window_wrapper_list: = []
var max_num_windows: int = 999999

func run_app() -> Node2D:
	if window_wrapper_list.size() == 1 and max_num_windows == 1:
		window_wrapper_list[0].window.place_on_top()
		return

	if window_wrapper_list.size() >= max_num_windows:
		return

	var window_wrapper: = _window_wrapper_scene.instantiate()
	window_wrapper.app = self
	window_wrapper_list.append(window_wrapper)
	
	_main_window_wrapper_list.add_child(window_wrapper)

	return window_wrapper.window
