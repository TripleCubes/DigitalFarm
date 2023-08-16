extends Node2D

@onready var window: Node2D = get_parent()

const _texture_cursor_downward_diagonal: Texture2D = preload("res://Assets/Sprites/UI/cursor_downward_diagonal.png")
const _texture_cursor_forward_diagonal: Texture2D = preload("res://Assets/Sprites/UI/cursor_forward_diagonal.png")
const _texture_cursor_top_down: Texture2D = preload("res://Assets/Sprites/UI/cursor_top_down.png")
const _texture_cursor_left_right: Texture2D = preload("res://Assets/Sprites/UI/cursor_left_right.png")
const _texture_cursor_pointer: Texture2D = preload("res://Assets/Sprites/UI/cursor_pointer.png")

var _prev_w: float = 0
var _prev_h: float = 0
var _prev_x: float = 0
var _prev_y: float = 0

func _ready():
	_set_element_locations()

func _update(_delta) -> void:
	show_hide_resize_buttons()
	_cursor_texture_handle()

	if App_ShowAllApps.running:
		return

	if not window.resizable:
		return

	if not resizing():
		return

	if Input.is_action_just_pressed("MOUSE_LEFT"):
		_prev_x = self.global_position.x
		_prev_y = self.global_position.y
		_prev_w = window.w
		_prev_h = window.h

	_resize_window()
	_set_element_locations()

func resizing() -> bool:
	return $Button_BorderTop.pressed() \
		or $Button_BorderBottom.pressed() \
		or $Button_BorderLeft.pressed() \
		or $Button_BorderRight.pressed() \
		or $Button_CornerTopLeft.pressed() \
		or $Button_CornerTopRight.pressed() \
		or $Button_CornerBottomLeft.pressed() \
		or $Button_CornerBottomRight.pressed()

func show_hide_resize_buttons() -> void:
	if not window.resizable or App_ShowAllApps.running:
		$Button_BorderTop.enabled = false
		$Button_BorderBottom.enabled = false
		$Button_BorderLeft.enabled = false
		$Button_BorderRight.enabled = false
		$Button_CornerTopLeft.enabled = false
		$Button_CornerTopRight.enabled = false
		$Button_CornerBottomLeft.enabled = false
		$Button_CornerBottomRight.enabled = false
		return

	$Button_BorderTop.enabled = true
	$Button_BorderBottom.enabled = true
	$Button_BorderLeft.enabled = true
	$Button_BorderRight.enabled = true
	$Button_CornerTopLeft.enabled = true
	$Button_CornerTopRight.enabled = true
	$Button_CornerBottomLeft.enabled = true
	$Button_CornerBottomRight.enabled = true

func _set_element_locations() -> void:
	var true_btn_w = Consts.BORDER_BUTTON_WIDTH - 4

	$Button_BorderTop.position.x = 0
	$Button_BorderTop.position.y = -25 - true_btn_w / 2
	$Button_BorderTop.w = window.w
	$Button_BorderTop.h = true_btn_w

	$Button_BorderBottom.position.x = 0
	$Button_BorderBottom.position.y = window.h + 1 - true_btn_w / 2
	$Button_BorderBottom.w = window.w
	$Button_BorderBottom.h = true_btn_w

	$Button_BorderLeft.position.x = -1 - true_btn_w / 2
	$Button_BorderLeft.position.y = -24
	$Button_BorderLeft.w = true_btn_w
	$Button_BorderLeft.h = window.h + window.BAR_HEIGHT

	$Button_BorderRight.position.x = window.w + 1 - true_btn_w / 2
	$Button_BorderRight.position.y = -24
	$Button_BorderRight.w = true_btn_w
	$Button_BorderRight.h = window.h + window.BAR_HEIGHT

	$Button_CornerTopLeft.position.x = -1 - true_btn_w / 2
	$Button_CornerTopLeft.position.y = -25 - true_btn_w / 2
	$Button_CornerTopLeft.w = true_btn_w
	$Button_CornerTopLeft.h = true_btn_w

	$Button_CornerTopRight.position.x = window.w + 1 - true_btn_w / 2
	$Button_CornerTopRight.position.y = -25 - true_btn_w / 2
	$Button_CornerTopRight.w = true_btn_w
	$Button_CornerTopRight.h = true_btn_w

	$Button_CornerBottomLeft.position.x = -1 - true_btn_w / 2
	$Button_CornerBottomLeft.position.y = window.h + 1 - true_btn_w / 2
	$Button_CornerBottomLeft.w = true_btn_w
	$Button_CornerBottomLeft.h = true_btn_w

	$Button_CornerBottomRight.position.x = window.w + 1 - true_btn_w / 2
	$Button_CornerBottomRight.position.y = window.h + 1 - true_btn_w / 2
	$Button_CornerBottomRight.w = true_btn_w
	$Button_CornerBottomRight.h = true_btn_w

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
	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	var max_w: float = window.max_w
	var min_w: float = window.min_w

	window.global_position.x = mouse_pos.x + 1
	window.w = _prev_w - (mouse_pos.x + 1 - _prev_x)

	if window.w > max_w:
		window.w = max_w
		window.global_position.x = _prev_x + _prev_w - window.w
	elif window.w < min_w:
		window.w = min_w
		window.global_position.x = _prev_x + _prev_w - window.w

func _resize_right() -> void:
	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	var max_w: float = window.max_w
	var min_w: float = window.min_w

	window.w = mouse_pos.x - 1 - _prev_x

	if window.w > max_w:
		window.w = max_w
	elif window.w < min_w:
		window.w = min_w

func _resize_top() -> void:
	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	var max_h: float = window.max_h
	var min_h: float = window.min_h
	var BAR_HEIGHT: float = window.BAR_HEIGHT

	window.global_position.y = mouse_pos.y + 1 + BAR_HEIGHT
	window.h = _prev_h - (mouse_pos.y + 1 - _prev_y) - BAR_HEIGHT

	if window.h > max_h:
		window.h = max_h
		window.global_position.y = _prev_y + _prev_h - window.h
	elif window.h < min_h:
		window.h = min_h
		window.global_position.y = _prev_y + _prev_h -window. h

func _resize_bottom() -> void:
	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	var max_h: float = window.max_h
	var min_h: float = window.min_h

	window.h = mouse_pos.y - 1 - _prev_y

	if window.h > max_h:
		window.h = max_h
	elif window.h < min_h:
		window.h = min_h

func _cursor_texture_handle() -> void:
	if not window.resizable:
		return

	if window.holding_bar():
		return

	if $Button_CornerTopLeft.pressed() or $Button_CornerBottomRight.pressed():
		Input.set_custom_mouse_cursor(_texture_cursor_downward_diagonal, Input.CURSOR_ARROW, Vector2(10, 10))
		return
	if $Button_CornerBottomLeft.pressed() or $Button_CornerTopRight.pressed():
		Input.set_custom_mouse_cursor(_texture_cursor_forward_diagonal, Input.CURSOR_ARROW, Vector2(10, 10))
		return
	if $Button_BorderBottom.pressed() or $Button_BorderTop.pressed():
		Input.set_custom_mouse_cursor(_texture_cursor_top_down, Input.CURSOR_ARROW, Vector2(10, 10))
		return
	if $Button_BorderLeft.pressed() or $Button_BorderRight.pressed():
		Input.set_custom_mouse_cursor(_texture_cursor_left_right, Input.CURSOR_ARROW, Vector2(10, 10))
		return

	if $Button_CornerTopLeft.hovered() or $Button_CornerBottomRight.hovered():
		Input.set_custom_mouse_cursor(_texture_cursor_downward_diagonal, Input.CURSOR_ARROW, Vector2(10, 10))
		return
	if $Button_CornerBottomLeft.hovered() or $Button_CornerTopRight.hovered():
		Input.set_custom_mouse_cursor(_texture_cursor_forward_diagonal, Input.CURSOR_ARROW, Vector2(10, 10))
		return
	if $Button_BorderBottom.hovered() or $Button_BorderTop.hovered():
		Input.set_custom_mouse_cursor(_texture_cursor_top_down, Input.CURSOR_ARROW, Vector2(10, 10))
		return
	if $Button_BorderLeft.hovered() or $Button_BorderRight.hovered():
		Input.set_custom_mouse_cursor(_texture_cursor_left_right, Input.CURSOR_ARROW, Vector2(10, 10))
		return

	Input.set_custom_mouse_cursor(_texture_cursor_pointer)
