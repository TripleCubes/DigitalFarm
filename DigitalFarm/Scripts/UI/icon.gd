@tool
extends Node2D

const _window_scene = preload("res://Scenes/window.tscn")
@onready var _window_list: = get_node("/root/Main/WindowList")

var _prev_x: float = 0
var _prev_y: float = 0
var _prev_mouse_x: float = 0
var _prev_mouse_y: float = 0

func _process(_delta):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("MOUSE_LEFT"):
			_prev_x = self.global_position.x
			_prev_y = self.global_position.y
			var mouse_pos: = get_global_mouse_position()
			_prev_mouse_x = mouse_pos.x
			_prev_mouse_y = mouse_pos.y

		_move_icon()
		_double_click_handle()

func _move_icon() -> void:
	var mouse_pos: = get_global_mouse_position()

	if not $Button.pressed():
		return

	self.global_position.x = _prev_x + (mouse_pos.x - _prev_mouse_x)
	self.global_position.y = _prev_y + (mouse_pos.y - _prev_mouse_y)

func _double_click_handle() -> void:
	if $Button.double_clicked():
		var window: = _window_scene.instantiate()
		window.position.x = 200
		window.position.y = 200
		_window_list.add_child(window)

