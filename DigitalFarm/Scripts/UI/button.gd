@tool
class_name UI_Button
extends Node2D

const DOUBLE_CLICK_DELAY_SEC: float = 0.5

@export var w: float
@export var h: float
@export var draw_frame: bool
@export var draw_background: bool
@export var draw_debug_frame: bool
@export var texture: Texture2D
@export var z: int
@export var window_clip: UI_WindowClip

var enabled: bool = true:
	set(val):
		enabled = val
	get:
		if not is_visible_in_tree():
			return false
		return enabled

var _hovered: = false
var _pressed: = false
var _just_pressed: = false
var _just_released: = false
var _double_clicked: = false
var _last_press_at: float = 0

func pressed() -> bool:
	return _pressed

func just_pressed() -> bool:
	return _just_pressed

func just_released() -> bool:
	return _just_released

func double_clicked() -> bool:
	return _double_clicked

func hovered() -> bool:
	return _hovered

func place_on_top() -> void:
	ButtonUpdater.place_button_on_top(self)

func _ready():
	if Engine.is_editor_hint():
		return

	ButtonUpdater.add_button(self)
	draw_debug_frame = ButtonUpdater.draw_button_debug_frame_enabled

func _draw():
	if not is_visible_in_tree():
		return

	var draw_w: = w
	var draw_h: = h
	if texture != null and (w == 0 or h == 0):
		draw_w = texture.get_width() * 2
		draw_h = texture.get_height() * 2
		
	if texture != null:
		draw_texture_rect(texture, Rect2(0, 0, draw_w, draw_h), false)

	var color_line: = Colors.COLOR_LINE_DAY
	var color_background: = Colors.COLOR_BACKGROUND_DAY

	if draw_frame:
		draw_rect(Rect2(0,      -2,     draw_w, 2     ), color_line, true)
		draw_rect(Rect2(0,      draw_h, draw_w, 2     ), color_line, true)
		draw_rect(Rect2(-2,     0,      2,      draw_h), color_line, true)
		draw_rect(Rect2(draw_w, 0,      2,      draw_h), color_line, true)

	if draw_background:
		draw_rect(Rect2(0, 0, w, h), color_background, true)

	if draw_debug_frame:
		draw_rect(Rect2(-2,             -2,             draw_w + 4, 1         ), Color("#ff0000"), true)
		draw_rect(Rect2(-2,             draw_h + 2 - 1, draw_w + 4, 1         ), Color("#ff0000"), true)
		draw_rect(Rect2(-2,             -2,             1,          draw_h + 4), Color("#ff0000"), true)
		draw_rect(Rect2(draw_w + 2 - 1, -2,             1,          draw_h + 4), Color("#ff0000"), true)

func _process(_delta):
	queue_redraw()

func _update(_delta) -> void:
	if not enabled:
		_hovered = false
		_pressed = false
		_just_pressed = false
		_just_released = false
		_double_clicked = false
		return
		
	_hover_check()
	_pressing_check()

func _before_update(_delta) -> void:
	_hovered = false

func _notification(what):
	if Engine.is_editor_hint():
		return
		
	if what == NOTIFICATION_PREDELETE:
		ButtonUpdater.remove_button(self)

func _hover_check() -> void:
	var check_w: = w
	var check_h: = h
	if texture != null and (w == 0 or h == 0):
		check_w = texture.get_width() * 2
		check_h = texture.get_height() * 2

	var clip_x0: float = 0
	var clip_y0: float = 0
	var clip_x1: float = get_viewport().size.x
	var clip_y1: float = get_viewport().size.y
	if window_clip != null:
		clip_x0 = window_clip.global_position.x                      + Consts.BORDER_BUTTON_WIDTH / 2
		clip_y0 = window_clip.global_position.y
		clip_x1 = window_clip.global_position.x + window_clip.size.x - Consts.BORDER_BUTTON_WIDTH / 2
		clip_y1 = window_clip.global_position.y + window_clip.size.y - Consts.BORDER_BUTTON_WIDTH / 2

	var x0 = max(global_position.x - 2, clip_x0)
	var y0 = max(global_position.y - 2, clip_y0)
	var x1 = min(global_position.x + check_w + 2, clip_x1)
	var y1 = min(global_position.y + check_h + 2, clip_y1)

	var mouse_pos = GlobalFunctions.get_mouse_pos()
	var mx = mouse_pos.x
	var my = mouse_pos.y
	if mx >= x0 and my >= y0 and mx <= x1 and my <= y1:
		_hovered = true

func _pressing_check() -> void:
	_just_released = false
	if Input.is_action_just_released("MOUSE_LEFT"):
		if _pressed:
			_just_released = true

		_pressed = false
		
	_just_pressed = false
	_double_clicked = false

	if not Input.is_action_just_pressed("MOUSE_LEFT"):
		return

	if not _hovered:
		return

	if Time.get_ticks_msec() - _last_press_at <= DOUBLE_CLICK_DELAY_SEC * 1000:
		_double_clicked = true
		_last_press_at = 0
	else:
		_last_press_at = Time.get_ticks_msec()

	_pressed = true
	_just_pressed = true
