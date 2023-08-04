@tool
class_name UI_Button
extends Node2D

const DOUBLE_CLICK_DELAY_SEC: float = 0.5

@export var w: float
@export var h: float
@export var draw_frame: bool
@export var draw_debug_frame: bool

var _pressed: = false
var _just_pressed: = false
var _double_clicked: = false
var _last_press_at: float = 0

func _ready():
	if not Engine.is_editor_hint():
		ButtonUpdater.add_button(self)

func _draw():
	if draw_frame:
		draw_rect(Rect2(0, 	-2, w, 2), Color(1, 1, 1), true)
		draw_rect(Rect2(0, 	h, 	w, 2), Color(1, 1, 1), true)
		draw_rect(Rect2(-2, 0, 	2, h), Color(1, 1, 1), true)
		draw_rect(Rect2(w, 	0, 	2, h), Color(1, 1, 1), true)

	if draw_debug_frame:
		draw_rect(Rect2(-2, 		-2, 		w + 4, 	1		), Color("#ff0000"), true)
		draw_rect(Rect2(-2, 		h + 2 - 1, 	w + 4, 	1		), Color("#ff0000"), true)
		draw_rect(Rect2(-2, 		-2,			1, 		h + 4	), Color("#ff0000"), true)
		draw_rect(Rect2(w + 2 - 1, 	-2,			1, 		h + 4	), Color("#ff0000"), true)

func _process(_delta):
	queue_redraw()

func _update(_delta) -> void:
	if Input.is_action_just_released("MOUSE_LEFT"):
		_pressed = false
	_just_pressed = false
	_double_clicked = false

	if not Input.is_action_just_pressed("MOUSE_LEFT"):
		return

	var mouse_pos = get_global_mouse_position()
	var mx = mouse_pos.x
	var my = mouse_pos.y
	var gx = global_position.x
	var gy = global_position.y

	if not (mx >= gx - 2 and my >= gy - 2 and mx <= gx + w + 2 and my <= gy + h + 2):
		return

	if Time.get_ticks_msec() - _last_press_at <= DOUBLE_CLICK_DELAY_SEC * 1000:
		_double_clicked = true
		_last_press_at = 0
	else:
		_last_press_at = Time.get_ticks_msec()

	_pressed = true
	_just_pressed = true
	ButtonUpdater.mark_button_pressed()

func pressed() -> bool:
	return _pressed

func just_pressed() -> bool:
	return _just_pressed

func double_clicked() -> bool:
	return _double_clicked
