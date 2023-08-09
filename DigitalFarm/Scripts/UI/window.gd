@tool
extends Node2D

const BAR_HEIGHT: float = 24
const BORDER_BUTTON_WIDTH: float = 6

@export var w: float:
	set(val):
		w = val
		if Engine.is_editor_hint():
			$Button_Close.position.x = w - 19
@export var h: float
@export var resizable: bool
@export var min_w: float
@export var min_h: float
@export var max_w: float
@export var max_h: float

var app: Node2D
var window_wrapper: Node2D

var _prev_w: float = 0
var _prev_h: float = 0
var _prev_x: float = 0
var _prev_y: float = 0
var _prev_mouse_x: float = 0
var _prev_mouse_y: float = 0

var _button_list: = []

func interacted() -> bool:
	for button in _button_list:
		if button == $Button_Close:
			continue

		if button.just_pressed():
			return true
	
	return false

func just_released() -> bool:
	return $Button_Bar.just_released()

func place_on_top() -> void:
	window_wrapper.move_to_front()

	for button in _button_list:
		button.place_on_top()

func released_on_window() -> Node2D:
	if not just_released():
		return null

	for window_comp in get_tree().get_nodes_in_group("Windows"):
		if GlobalFunctions.windows_overllap(self, window_comp):
			return window_comp

	return null

func _ready():
	if not Engine.is_editor_hint():
		window_wrapper = self.get_parent()
		if window_wrapper != null:
			app = window_wrapper.app

		_set_button_list()

	self.position.x = 200
	self.position.y = 200
	
	_set_buttons()

	if not resizable:
		$Button_BorderTop.enabled = false
		$Button_BorderBottom.enabled = false
		$Button_BorderLeft.enabled = false
		$Button_BorderRight.enabled = false
		$Button_CornerTopLeft.enabled = false
		$Button_CornerTopRight.enabled = false
		$Button_CornerBottomLeft.enabled = false
		$Button_CornerBottomRight.enabled = false
		return

	if w > max_w:
		print_stack()
		print("w > max_w")
	if h > max_h:
		print_stack()
		print("h > max_h")
	if w < min_w:
		print_stack()
		print("w < min_w")
	if h < min_h:
		print_stack()
		print("h < min_h")

	if min_w == 0:
		min_w = 120
	if min_h == 0:
		min_h = 120
	if max_w == 0:
		max_w = 400
	if max_h == 0:
		max_h = 400
	if w == 0:
		w = 120
	if h == 0:
		h = 120

func _draw():
	draw_rect(Rect2(0,  - BAR_HEIGHT - 2, w, h + BAR_HEIGHT + 2), Consts.COLOR_BACKGROUND, true)
	draw_rect(Rect2(0,  - BAR_HEIGHT - 2, w, 2                 ), Consts.COLOR_LINE, true)
	draw_rect(Rect2(0,  -2,               w, 2                 ), Consts.COLOR_LINE, true)
	draw_rect(Rect2(0,  h,                w, 2                 ), Consts.COLOR_LINE, true)
	draw_rect(Rect2(-2, - BAR_HEIGHT,     2, h + BAR_HEIGHT    ), Consts.COLOR_LINE, true)
	draw_rect(Rect2(w,  - BAR_HEIGHT,     2, h + BAR_HEIGHT    ), Consts.COLOR_LINE, true)

func _process(_delta):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("MOUSE_LEFT"):
			_prev_x = self.global_position.x
			_prev_y = self.global_position.y
			_prev_w = w
			_prev_h = h
			var mouse_pos: = get_global_mouse_position()
			_prev_mouse_x = mouse_pos.x
			_prev_mouse_y = mouse_pos.y
		if resizable:
			_resize_window()
		_move_window()
		
		_set_buttons()

		if $Button_Close.just_pressed():
			queue_free()

		if interacted():
			place_on_top()
	
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if window_wrapper != null:
			app.window_wrapper_list.erase(window_wrapper)
			window_wrapper.queue_free()

func _set_button_list() -> void:
	_button_search(self)

func _button_search(node: Node2D) -> void:
	for search in node.get_children():
		if search is UI_Button:
			_button_list.append(search)
			continue
		
		if search.get_child_count() > 0:
			_button_search(search)

func _set_buttons() -> void:
	$Button_Bar.w = w
	$Button_Bar.h = BAR_HEIGHT - 2

	$Button_Content.w = w
	$Button_Content.h = h

	var true_btn_w = BORDER_BUTTON_WIDTH - 4

	$Button_BorderTop.position.x = 0
	$Button_BorderTop.position.y = -25 - true_btn_w / 2
	$Button_BorderTop.w = w
	$Button_BorderTop.h = true_btn_w

	$Button_BorderBottom.position.x = 0
	$Button_BorderBottom.position.y = h + 1 - true_btn_w / 2
	$Button_BorderBottom.w = w
	$Button_BorderBottom.h = true_btn_w

	$Button_BorderLeft.position.x = -1 - true_btn_w / 2
	$Button_BorderLeft.position.y = -24
	$Button_BorderLeft.w = true_btn_w
	$Button_BorderLeft.h = h + BAR_HEIGHT

	$Button_BorderRight.position.x = w + 1 - true_btn_w / 2
	$Button_BorderRight.position.y = -24
	$Button_BorderRight.w = true_btn_w
	$Button_BorderRight.h = h + BAR_HEIGHT

	$Button_CornerTopLeft.position.x = -1 - true_btn_w / 2
	$Button_CornerTopLeft.position.y = -25 - true_btn_w / 2
	$Button_CornerTopLeft.w = true_btn_w
	$Button_CornerTopLeft.h = true_btn_w

	$Button_CornerTopRight.position.x = w + 1 - true_btn_w / 2
	$Button_CornerTopRight.position.y = -25 - true_btn_w / 2
	$Button_CornerTopRight.w = true_btn_w
	$Button_CornerTopRight.h = true_btn_w

	$Button_CornerBottomLeft.position.x = -1 - true_btn_w / 2
	$Button_CornerBottomLeft.position.y = h + 1 - true_btn_w / 2
	$Button_CornerBottomLeft.w = true_btn_w
	$Button_CornerBottomLeft.h = true_btn_w

	$Button_CornerBottomRight.position.x = w + 1 - true_btn_w / 2
	$Button_CornerBottomRight.position.y = h + 1 - true_btn_w / 2
	$Button_CornerBottomRight.w = true_btn_w
	$Button_CornerBottomRight.h = true_btn_w

	$Button_Close.position.x = w - 19
	$Button_Close.position.y = -20

func _resize_window() -> void:
	if $Button_BorderLeft.pressed():
		_resize_left()

	if $Button_BorderRight.pressed():
		_resize_right()

	if $Button_BorderTop.pressed():
		_resize_top()

	if $Button_BorderBottom.pressed():
		_resize_bottom()

	if $Button_CornerTopLeft.pressed():
		_resize_top()
		_resize_left()

	if $Button_CornerTopRight.pressed():
		_resize_top()
		_resize_right()

	if $Button_CornerBottomLeft.pressed():
		_resize_bottom()
		_resize_left()

	if $Button_CornerBottomRight.pressed():
		_resize_bottom()
		_resize_right()

func _resize_left() -> void:
	var mouse_pos: = get_global_mouse_position()

	self.global_position.x = mouse_pos.x + 1
	w = _prev_w - (mouse_pos.x + 1 - _prev_x)

	if w > max_w:
		w = max_w
		self.global_position.x = _prev_x + _prev_w - w
	elif w < min_w:
		w = min_w
		self.global_position.x = _prev_x + _prev_w - w

func _resize_right() -> void:
	var mouse_pos: = get_global_mouse_position()

	w = mouse_pos.x + 1 - _prev_x

	if w > max_w:
		w = max_w
	elif w < min_w:
		w = min_w

func _resize_top() -> void:
	var mouse_pos: = get_global_mouse_position()

	self.global_position.y = mouse_pos.y + 1 + BAR_HEIGHT
	h = _prev_h - (mouse_pos.y + 1 - _prev_y) - BAR_HEIGHT

	if h > max_h:
		h = max_h
		self.global_position.y = _prev_y + _prev_h - h
	elif h < min_h:
		h = min_h
		self.global_position.y = _prev_y + _prev_h - h

func _resize_bottom() -> void:
	var mouse_pos: = get_global_mouse_position()

	h = mouse_pos.y + 1 - _prev_y

	if h > max_h:
		h = max_h
	elif h < min_h:
		h = min_h

func _move_window() -> void:
	var mouse_pos: = get_global_mouse_position()

	if not $Button_Bar.pressed():
		return

	self.global_position.x = _prev_x + (mouse_pos.x - _prev_mouse_x)
	self.global_position.y = _prev_y + (mouse_pos.y - _prev_mouse_y)
