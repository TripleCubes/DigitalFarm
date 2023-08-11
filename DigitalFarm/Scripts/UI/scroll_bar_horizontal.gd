@tool
class_name UI_ScrollBarHorizontal
extends Node2D

@export var length: float:
	set(val):
		length = val
		_button.w = length - 8
@export var width: float:
	set(val):
		width = val
		_button.h = width - 8
var _page_length: float = 0
var _view_length: float = 0
var _bar_length: float = 0

var _prev_cursor_x: float = 0
var _prev_btn_x: float = 0

var _scrolled_percentage = 0

func get_scrolled_pixel() -> float:
	if _button.visible:
		return - _scrolled_percentage * (_page_length - _view_length)
	
	return 0

func scrolling() -> bool:
	return _button.pressed()

func set_page_length(page_length: float, view_length: float) -> void:
	if page_length - view_length <= 0:
		_button.hide()
		return

	_button.show()
	_page_length = page_length
	_view_length = view_length
	_bar_length = view_length / page_length * length
	_button.w = _bar_length - 8

	_button.position.x = _scrolled_percentage * (length - _bar_length) + 4

var _button: = UI_Button.new()

func _ready():
	_button.draw_frame = true
	_button.draw_background = true
	_button.position.x = 4
	_button.position.y = 4
	add_child(_button)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	var mouse_pos = GlobalFunctions.get_local_mouse_pos(self)

	if _button.just_pressed():
		_prev_cursor_x = mouse_pos.x
		_prev_btn_x = _button.position.x

	if _button.pressed():
		_button.position.x = _prev_btn_x + (mouse_pos.x - _prev_cursor_x)
		if _button.position.x < 4:
			_button.position.x = 4

		if _button.position.x + _button.w > length - 4:
			_button.position.x = length - 4 - _button.w

		_scrolled_percentage = (_button.position.x - 4) / (length - _bar_length)
