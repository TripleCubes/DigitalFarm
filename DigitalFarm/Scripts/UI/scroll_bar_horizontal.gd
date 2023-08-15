@tool
class_name UI_ScrollBarHorizontal
extends Node2D

const SCROLL_TWEEN_TIME_SEC: float = 0.05

@export var length: float:
	set(val):
		length = val
		button.w = length - 8
@export var width: float:
	set(val):
		width = val
		button.h = width - 8
var _page_length: float = 0
var _view_length: float = 0
var _bar_length: float = 0

var _prev_cursor_x: float = 0
var _prev_btn_x: float = 0

var _scrolled_percentage: float = 0

var _just_scrolled_at: float = 0

func scroll(amount_pixel: float) -> void:
	var scroll_amount: float = amount_pixel / (_page_length - _view_length) * (length - button.h)
	var move_to: = Vector2(button.position.x + scroll_amount, button.position.y)

	if move_to.x < 4:
		move_to.x = 4

	if move_to.x + button.w > length - 4:
		move_to.x = length - 4 - button.w

	var tween = get_tree().create_tween()
	tween.tween_property(button, "position", move_to, SCROLL_TWEEN_TIME_SEC)

	_just_scrolled_at = Time.get_ticks_msec()

func scroll_to_zero() -> void:
	button.position.x = 4
	_scrolled_percentage = 0

	_just_scrolled_at = Time.get_ticks_msec()

func get_scrolled_pixel() -> float:
	if button.visible:
		return - _scrolled_percentage * (_page_length - _view_length)
	
	return 0

func scrolling() -> bool:
	return Time.get_ticks_msec() - _just_scrolled_at < (SCROLL_TWEEN_TIME_SEC + 0.05) * 1000

func should_be_visible() -> bool:
	return _page_length - _view_length > 0

func set_page_length(page_length: float, view_length: float) -> void:
	_page_length = page_length
	_view_length = view_length
	
	if not should_be_visible():
		button.hide()
		return

	button.show()
	_bar_length = view_length / page_length * length
	button.w = _bar_length - 8

	button.position.x = _scrolled_percentage * (length - _bar_length) + 4

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
		_prev_cursor_x = mouse_pos.x
		_prev_btn_x = button.position.x

	if button.pressed():
		button.position.x = _prev_btn_x + (mouse_pos.x - _prev_cursor_x)
		if button.position.x < 4:
			button.position.x = 4

		if button.position.x + button.w > length - 4:
			button.position.x = length - 4 - button.w

		_just_scrolled_at = Time.get_ticks_msec()

	if scrolling():
		_scrolled_percentage = (button.position.x - 4) / (length - _bar_length)
