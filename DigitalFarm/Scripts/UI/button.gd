@tool
class_name UI_Button
extends Node2D

const DOUBLE_CLICK_DELAY_SEC: float = 0.5

@export var w: float
@export var h: float
@export var draw_frame: bool
@export var draw_debug_frame: bool
@export var texture: Texture2D
@export var z: int

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
	if not Engine.is_editor_hint():
		ButtonUpdater.add_button(self)
		draw_debug_frame = ButtonUpdater.draw_button_debug_frame_enabled

func _draw():
	if not visible:
		return

	var draw_w: = w
	var draw_h: = h
	if texture != null and (w == 0 or h == 0):
		draw_w = texture.get_width() * 2
		draw_h = texture.get_height() * 2
		
	if texture != null:
		draw_texture_rect(texture, Rect2(0, 0, draw_w, draw_h), false)

	if draw_frame:
		draw_rect(Rect2(0,      -2,     draw_w, 2     ), Consts.COLOR_LINE, true)
		draw_rect(Rect2(0,      draw_h, draw_w, 2     ), Consts.COLOR_LINE, true)
		draw_rect(Rect2(-2,     0,      2,      draw_h), Consts.COLOR_LINE, true)
		draw_rect(Rect2(draw_w, 0,      2,      draw_h), Consts.COLOR_LINE, true)

	if draw_debug_frame:
		draw_rect(Rect2(-2,             -2,             draw_w + 4, 1         ), Color("#ff0000"), true)
		draw_rect(Rect2(-2,             draw_h + 2 - 1, draw_w + 4, 1         ), Color("#ff0000"), true)
		draw_rect(Rect2(-2,             -2,             1,          draw_h + 4), Color("#ff0000"), true)
		draw_rect(Rect2(draw_w + 2 - 1, -2,             1,          draw_h + 4), Color("#ff0000"), true)

func _process(_delta):
	if not visible:
		return
		
	queue_redraw()

func _update(_delta) -> void:
	if not visible:
		return
		
	_hover_check()
	_pressing_check()

func _notification(what):
	if Engine.is_editor_hint():
		return
		
	if what == NOTIFICATION_PREDELETE:
		ButtonUpdater.remove_button(self)

func _hover_check() -> void:
	_hovered = false

	var check_w: = w
	var check_h: = h
	if texture != null and (w == 0 or h == 0):
		check_w = texture.get_width() * 2
		check_h = texture.get_height() * 2

	var mouse_pos = get_global_mouse_position()
	var mx = mouse_pos.x
	var my = mouse_pos.y
	var gx = global_position.x
	var gy = global_position.y
	if (mx >= gx - 2 and my >= gy - 2 and mx <= gx + check_w + 2 and my <= gy + check_h + 2):
		_hovered = true

func _pressing_check() -> void:
	_just_released = false
	if Input.is_action_just_released("MOUSE_LEFT"):
		if _hovered:
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
	ButtonUpdater.mark_button_pressed()
