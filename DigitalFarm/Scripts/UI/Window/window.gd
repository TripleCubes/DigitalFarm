@tool
extends Node2D

const BAR_HEIGHT: float = 24

signal signal_resize

@export var w: float:
	set(val):
		w = val
		if not Engine.is_editor_hint():
			return

		if has_node("Button_Close"):
			$Button_Close.position.x = w - 19

		if has_node("ScrollBars"):
			$ScrollBars.set_element_locations()

		if has_node("CornerPixelTopRight"):
			$CornerPixelTopRight.position.x = w - 2
		if has_node("CornerPixelBottomRight"):
			$CornerPixelBottomRight.position.x = w - 2

		signal_resize.emit()

@export var h: float:
	set(val):
		h = val
		if not Engine.is_editor_hint():
			return

		if has_node("ScrollBars"):
			$ScrollBars.set_element_locations()

		if has_node("CornerPixelBottomLeft"):
			$CornerPixelBottomLeft.position.y = h - 2
		if has_node("CornerPixelBottomRight"):
			$CornerPixelBottomRight.position.y = h - 2

		signal_resize.emit()

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

func hovered() -> bool:
	for button in _button_list:
		if button.hovered():
			return true
	
	return false

func content_hovered() -> bool:
	return $Button_Content.hovered()

func close_button_pressed() -> bool:
	return $Button_Close.pressed()

func holding_bar() -> bool:
	return $Button_Bar.pressed()

func just_released() -> bool:
	return $Button_Bar.just_released()

func resizing() -> bool:
	return $Buttons_BordersCorners.resizing()

func place_on_top() -> void:
	window_wrapper.move_to_front()

	for button in _button_list:
		button.place_on_top()

func released_on_window() -> Node2D:
	if not just_released():
		return null

	var window_list = get_tree().get_nodes_in_group("Windows")
	for i in range(window_list.size() - 1, -1, -1):
		var window_comp: Node2D = window_list[i]
		if window_comp == self:
			continue
			
		if GlobalFunctions.windows_overllap(self, window_comp):
			return window_comp

	return null

func enable_buttons() -> void:
	for button in _button_list:
		button.enabled = true
		$Buttons_BordersCorners.show_hide_resize_buttons()

func disable_buttons() -> void:
	for button in _button_list:
		button.enabled = false

	$Button_Close.enabled = true

func set_button_list() -> void:
	_button_list.clear()
	_button_search(self)

func throw_window_out(window: Node2D) -> void:
	const THROW_PADDING: float = 20

	place_on_top()

	window.position.x = self.position.x + self.w/2 - window.w/2
	window.position.y = self.position.y + self.h/2 - window.h/2

	var move_to: = Vector2(0, 0)

	if get_viewport().size.x - (self.position.x + self.w) > window.w + THROW_PADDING - 20:
		move_to.x = self.position.x + self.w + THROW_PADDING
		move_to.y = window.position.y
	elif get_viewport().size.y - (self.position.y + self.h) > window.h + BAR_HEIGHT + THROW_PADDING - 20:
		move_to.x = window.position.x
		move_to.y = self.position.y + BAR_HEIGHT + self.h + THROW_PADDING
	elif self.position.x > window.w + THROW_PADDING - 20:
		move_to.x = self.position.x - window.w - THROW_PADDING
		move_to.y = window.position.y
	elif self.position.y - BAR_HEIGHT > window.h + THROW_PADDING + 15:
		move_to.x = window.position.x
		move_to.y = self.position.y - window.h - THROW_PADDING - BAR_HEIGHT

	move_to += Vector2(randf_range(-15, 15), randf_range(-15, 15))
	if move_to.y < BAR_HEIGHT + 2:
		move_to.y = BAR_HEIGHT + 2

	var tween_0: = get_tree().create_tween()
	tween_0.tween_property(window, "position", move_to, Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)

func window_dragged_into_app(app_comp: App) -> bool:
	var window_check = GlobalFunctions.cursor_inside_of_window(self)

	if self.holding_bar() and window_check != null and window_check.app == app_comp:
		return true

	return false

func _ready():
	if not Engine.is_editor_hint():
		window_wrapper = self.get_parent()
		if window_wrapper != null:
			app = window_wrapper.app

		move_child($ScrollBars, get_child_count() - 1)

		move_child($CornerPixelTopLeft, get_child_count() - 1)
		move_child($CornerPixelTopRight, get_child_count() - 1)
		move_child($CornerPixelBottomLeft, get_child_count() - 1)
		move_child($CornerPixelBottomRight, get_child_count() - 1)

		set_button_list()

		self.position.x = (get_viewport().size.x - w) / 2 + randf_range(-100, 100)
		self.position.y = (get_viewport().size.y - h) / 2 + randf_range(-100, 100)
	
	_set_element_locations()
	# This line is not in $ScrollBars._ready() because $ScrollBars init before window and
	# $ScrollBars.set_element_locations() need window_clip.content_h which need window.max_h
	# which require widnow to be loaded
	$ScrollBars.set_element_locations()
	_set_init_window_sizes()

func _draw():
	var color_line: = Colors.COLOR_LINE_DAY
	var color_background: = Colors.COLOR_BACKGROUND_DAY

	# Background
	draw_rect(Rect2(0,  - BAR_HEIGHT    , w,     h + BAR_HEIGHT    ), color_background, true)

	# Top border
	draw_rect(Rect2(2,  - BAR_HEIGHT - 2, w - 4, 2                 ), color_line, true)
	# Middle border
	draw_rect(Rect2(0,  -2,               w,     2                 ), color_line, true)
	# Bottom border
	draw_rect(Rect2(2,  h,                w - 4, 2                 ), color_line, true)
	# Left border
	draw_rect(Rect2(-2, - BAR_HEIGHT + 2, 2,     h + BAR_HEIGHT - 4), color_line, true)
	# Right border
	draw_rect(Rect2(w,  - BAR_HEIGHT + 2, 2,     h + BAR_HEIGHT - 4), color_line, true)

func _process(_delta):
	if not Engine.is_editor_hint():
		_print_debug_messages()
		
		# Not using $Buttons_BordersCorners._process() because doing so will make window elements's
		# positions lag behind resizing. Might as well use $ScrollBars._update() to be consistent.
		$Buttons_BordersCorners._update(_delta)
		$ScrollBars._update(_delta)
		_pressing_process()

		if resizing():
			signal_resize.emit()

	queue_redraw()

func _print_debug_messages() -> void:
	if hovered() and Input.is_action_just_pressed("KEY_2"):
		print("Window size: " + str(w) + " " + str(h))

		var mouse_pos: Vector2 = GlobalFunctions.get_mouse_pos() - self.position
		mouse_pos.x -= $ScrollBars/ScrollBarHorizontal.get_scrolled_pixel()
		mouse_pos.y -= $ScrollBars/ScrollBarVertical.get_scrolled_pixel()
		print("In window mouse pos: " + str(mouse_pos))

func _set_init_window_sizes() -> void:
	if w == 0:
		w = 120
	if h == 0:
		h = 120

	if not resizable:
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

func _pressing_process() -> void:
	if App_ShowAllApps.running:
		return

	if Input.is_action_just_pressed("MOUSE_LEFT"):
		_prev_x = self.global_position.x
		_prev_y = self.global_position.y
		_prev_w = w
		_prev_h = h
		var mouse_pos: = GlobalFunctions.get_mouse_pos()
		_prev_mouse_x = mouse_pos.x
		_prev_mouse_y = mouse_pos.y

	_move_window()
	
	if resizing():
		_set_element_locations()

	if $Button_Close.just_pressed():
		queue_free()

	if interacted():
		place_on_top()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if window_wrapper != null:
			app.window_wrapper_list.erase(window_wrapper)
			window_wrapper.queue_free()

func _button_search(node: Node) -> void:
	for search in node.get_children():
		if search is UI_Button:
			_button_list.append(search)
			continue
		
		if search.get_child_count() > 0:
			_button_search(search)

func _set_element_locations() -> void:
	$Button_Bar.w = w
	$Button_Bar.h = BAR_HEIGHT - 2

	$Button_Content.w = w
	$Button_Content.h = h

	$Button_Close.position.x = w - 19
	$Button_Close.position.y = -20

	$CornerPixelTopLeft.position.x = 0
	$CornerPixelTopLeft.position.y = 0 - BAR_HEIGHT

	$CornerPixelTopRight.position.x = w - 2
	$CornerPixelTopRight.position.y = 0 - BAR_HEIGHT

	$CornerPixelBottomLeft.position.x = 0
	$CornerPixelBottomLeft.position.y = h - 2
	
	$CornerPixelBottomRight.position.x = w - 2
	$CornerPixelBottomRight.position.y = h - 2

func _move_window() -> void:
	var mouse_pos: = GlobalFunctions.get_mouse_pos()

	if $Button_Bar.pressed():
		self.global_position.x = _prev_x + (mouse_pos.x - _prev_mouse_x)
		self.global_position.y = _prev_y + (mouse_pos.y - _prev_mouse_y)

	if $Button_Bar.just_released():
		var move_to: = Vector2(self.position.x, self.position.y)
		if self.position.x + w - 40 < 0:
			move_to.x = 40 - w
		if self.position.y < BAR_HEIGHT + 2:
			move_to.y = BAR_HEIGHT + 2
		if self.position.x + 20 > get_viewport().size.x:
			move_to.x = get_viewport().size.x - 20
		if self.position.y + 20 > get_viewport().size.y:
			move_to.y = get_viewport().size.y - 20

		var _tween: = get_tree().create_tween()
		_tween.tween_property(self, "position", move_to, Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)
