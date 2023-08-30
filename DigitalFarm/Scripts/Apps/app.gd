class_name App
extends Node2D

@onready var _main_window_wrapper_list: Node2D = get_node(Consts.MAIN_NODE_PATH + "WindowWrapperList")
@onready var _icon_list: Node2D = get_node(Consts.MAIN_NODE_PATH + "IconList")
@onready var _hidden_icon_list: Node2D = get_node(Consts.MAIN_NODE_PATH + "HiddenIconList")

@onready var icon: = _get_app_icon()
var _window_wrapper_scene: PackedScene

var window_wrapper_list: = []
var max_num_windows: int = 999999

func run_app() -> Node2D:
	if window_wrapper_list.size() == 1 and max_num_windows == 1:
		window_wrapper_list[0].window.put_wrapper_to_main_wrapper_list()
		window_wrapper_list[0].window.place_on_top()
		return

	if window_wrapper_list.size() >= max_num_windows:
		return

	var window_wrapper: = _window_wrapper_scene.instantiate()
	window_wrapper.app = self
	window_wrapper_list.append(window_wrapper)
	
	_main_window_wrapper_list.add_child(window_wrapper)

	return window_wrapper.window

func download_app() -> void:
	if downloaded():
		return

	_hidden_icon_list.remove_child(icon)
	_icon_list.add_child(icon)
	icon.show()
	icon.place_on_top()

func delete_app() -> void:
	if not downloaded():
		return

	icon.hide()
	_icon_list.remove_child(icon)
	_hidden_icon_list.add_child(icon)

	for window_wrapper in window_wrapper_list:
		window_wrapper.window.queue_free()

func downloaded() -> bool:
	return icon.is_visible_in_tree()

func _get_app_icon() -> Node2D:
	for icon_comp in _icon_list.get_children():
		if AppNames.app_list[icon_comp.app_name] == self:
			return icon_comp

	return null
