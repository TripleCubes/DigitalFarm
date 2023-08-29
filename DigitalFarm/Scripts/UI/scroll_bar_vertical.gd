@tool
class_name UI_ScrollBarVertical
extends Node2D

const SCROLL_TWEEN_TIME_SEC: float = 0.02

@export var length: float:
	set(val):
		length = val
		button.h = length - 8
@export var width: float:
	set(val):
		width = val
		button.w = width - 8
var _page_length: float = 0
var _view_length: float = 0
var _bar_length: float = 0

var _prev_cursor_y: float = 0
var _prev_btn_y: float = 0

var _scrolled_percentage: float = 0

var _just_scrolled_at: float = 0

func scroll_to_zero() -> void:
	button.position.y = 4
	_scrolled_percentage = 0

	_just_scrolled_at = Time.get_ticks_msec()

func scroll(amount_pixel: float) -> void:
	var scroll_amount: float = amount_pixel / (_page_length - _view_length) * (length - button.h)
	var move_to: = Vector2(button.position.x, button.position.y + scroll_amount)

	if move_to.y < 4:
		move_to.y = 4

	if move_to.y + button.h > length - 4:
		move_to.y = length - 4 - button.h

	var tween = get_tree().create_tween()
	tween.tween_property(button, "position", move_to, SCROLL_TWEEN_TIME_SEC)

	_just_scrolled_at = Time.get_ticks_msec()

func get_scrolled_pixel() -> float:
	if button.visible:
		return - _scrolled_percentage * (_page_length - _view_length)
	
	return 0

func scrolling() -> bool:
	return Time.get_ticks_msec() - _just_scrolled_at < (SCROLL_TWEEN_TIME_SEC + 0.05) * 1000

func should_be_visible() -> bool:
	return _page_length - _view_length > 0

func set_page_length(page_length: float, view_length: float, page_length_resizing: bool) -> void:
	var prev_scrolled_pixel = get_scrolled_pixel()
	_page_length = page_length
	_view_length = view_length
	
	if not should_be_visible():
		button.hide()
		return

	button.show()
	_bar_length = view_length / page_length * length
	button.h = _bar_length - 8

	if page_length_resizing:
		_scrolled_percentage = - prev_scrolled_pixel / (_page_length - _view_length)
		if _scrolled_percentage > 1:
			_scrolled_percentage = 1
	button.position.y = _scrolled_percentage * (length - _bar_length) + 4

var button: = UI_Button.new()

func _ready():
	button.draw_frame = true
	button.draw_background = true
	button.position.x = 4
	button.position.y = 4
	add_child(button)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	var mouse_pos = GlobalFunctions.get_local_mouse_pos(self)

	if button.just_pressed():
		_prev_cursor_y = mouse_pos.y
		_prev_btn_y = button.position.y

	if button.pressed():
		button.position.y = _prev_btn_y + (mouse_pos.y - _prev_cursor_y)
		if button.position.y < 4:
			button.position.y = 4

		if button.position.y + button.h > length - 4:
			button.position.y = length - 4 - button.h

		_just_scrolled_at = Time.get_ticks_msec()

	if scrolling():
		_scrolled_percentage = (button.position.y - 4) / (length - _bar_length)
