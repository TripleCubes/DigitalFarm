extends App

@onready var _window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "WindowWrapperList")

const PADDING_LEFT: float = 10
const PADDING_RIGHT: float = 30
const PADDING_TOP: float = 10
const PADDING_BOTTOM: float = 50

const WINDOW_PADDING_LEFT: float = 60
const WINDOW_SPACING_H: float = 5
const WINDOW_SPACING_V: float = 5
const APP_SPACING: float = 10
const APP_SPACING_EMPTY: float = 60

var _running = false
var running:
	set(_val):
		if _running:
			run_app()
		else:
			close_app()
	get:
		return _running

var _initial_icon_order: = []
var _prev_window_pos_list: = []
var _prev_icon_pos_list: = []

var _scroll_bar: = UI_ScrollBarVertical.new()

func run_app() -> Node2D:
	if _running:
		return

	if _window_wrapper_list.get_child_count() == 0:
		return

	_disable_window_buttons()
	_update_prev_pos_lists()
	_scroll_bar.scroll_to_zero()
	var _cursor_y = _move_icons_and_windows(true)
	_scroll_bar.show()
	_scroll_bar.set_page_length(_cursor_y + PADDING_BOTTOM, get_viewport().size.y, false)

	_running = true

	return null

func close_app() -> void:
	if not _running:
		return

	_return_icons_and_windows()
	var timer: = get_tree().create_timer(Consts.TWEEN_TIME_SEC)
	timer.timeout.connect(func():
		_enable_window_buttons()
	)
	_scroll_bar.hide()
		
	_running = false

func _ready():
	for icon_comp in get_node(Consts.MAIN_NODE_PATH + "IconList").get_children():
		_initial_icon_order.append(icon_comp)

	_scroll_bar.length = get_viewport().size.y
	_scroll_bar.width = 20
	_scroll_bar.position.x = get_viewport().size.x - 20
	_scroll_bar.hide()
	get_node(Consts.MAIN_NODE_PATH).add_child(_scroll_bar)

func _process(_delta):
	if not running:
		return

	if _window_wrapper_list.get_child_count() == 0:
		close_app()
		return

	_scroll_wheel_handle(_delta)

	if _scroll_bar.scrolling():
		_move_icons_and_windows(false)

	_windows_pressing_check()

func _update_prev_pos_lists() -> void:
	_prev_window_pos_list.clear()
	_prev_icon_pos_list.clear()

	for window in get_tree().get_nodes_in_group("Windows"):
		if not window.is_visible_in_tree():
			continue

		_prev_window_pos_list.append({
			window = window,
			pos = Vector2(window.position.x, window.position.y),
		})

	for icon_comp in _initial_icon_order:
		if not icon_comp.is_visible_in_tree():
			continue

		_prev_icon_pos_list.append({
			icon = icon_comp,
			pos = Vector2(icon_comp.position.x, icon_comp.position.y),
		})

func _move_icons_and_windows(tween: bool) -> float:
	var scrolled_pixel: = _scroll_bar.get_scrolled_pixel()
	var _cursor_x: float = WINDOW_PADDING_LEFT
	var _cursor_y: float = PADDING_TOP + scrolled_pixel

	for icon_comp in _initial_icon_order:
		if not icon_comp.is_visible_in_tree():
			continue

		if tween:
			var _tween_0: = get_tree().create_tween()
			_tween_0.tween_property(icon_comp, "position", Vector2(PADDING_LEFT, _cursor_y), 
										Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)
		else:
			icon_comp.position.x = PADDING_LEFT
			icon_comp.position.y = _cursor_y

		var app_name: AppNames.Name = icon_comp.app_name
		var max_window_h: float = 0
		for window in get_tree().get_nodes_in_group("Windows"):
			if window.is_queued_for_deletion():
				continue

			if not window.is_visible_in_tree():
				continue
				
			if window.app != AppNames.app_list[app_name]:
				continue

			if _cursor_x + window.w > get_viewport().size.x - PADDING_RIGHT:
				_cursor_x = WINDOW_PADDING_LEFT
				_cursor_y += max_window_h / 2 + WINDOW_SPACING_V
				max_window_h = 0

			if tween:
				var _tween_1: = get_tree().create_tween()
				_tween_1.tween_property(window, "position", Vector2(_cursor_x, _cursor_y + window.BAR_HEIGHT/2), 
										Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)
				var _tween_2: = get_tree().create_tween()
				_tween_2.tween_property(window, "scale", Vector2(0.501, 0.501), 
										Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)
			else:
				window.position.x = _cursor_x
				window.position.y = _cursor_y + window.BAR_HEIGHT/2
				window.scale.x = 0.501
				window.scale.y = 0.501

			if max_window_h < window.h:
				max_window_h = window.h + window.BAR_HEIGHT

			_cursor_x += window.w / 2 + WINDOW_SPACING_H
		
		_cursor_x = WINDOW_PADDING_LEFT
		if max_window_h != 0: 
			_cursor_y += max_window_h / 2 + APP_SPACING
		else:
			_cursor_y += APP_SPACING_EMPTY
	
	return _cursor_y - scrolled_pixel

func _windows_pressing_check():
	var mouse_pos = GlobalFunctions.get_mouse_pos()

	var clicked: = func(window: Node2D) -> bool:
		return Input.is_action_just_pressed("MOUSE_LEFT") and \
				mouse_pos.x >= window.position.x and \
				mouse_pos.y >= window.position.y - window.BAR_HEIGHT / 2 and \
				mouse_pos.x <= window.position.x + window.w / 2 and \
				mouse_pos.y <= window.position.y + window.h / 2

	var clicked_close: = func(window: Node2D) -> bool:
		var x: float = window.position.x + (window.w - 19) / 2 - 2
		var y: float = window.position.y - 10 - 2
		return Input.is_action_just_pressed("MOUSE_LEFT") and \
				mouse_pos.x >= x and \
				mouse_pos.y >= y and \
				mouse_pos.x <= x + 7 + 4 and \
				mouse_pos.y <= y + 7 + 4

	for window_pos in _prev_window_pos_list:
		if not is_instance_valid(window_pos.window):
			continue

		if not window_pos.window.is_visible_in_tree():
			continue
			
		var window: Node2D = window_pos.window

		if clicked_close.call(window):
			window.close_window()
			_move_icons_and_windows(true)
			return

		if clicked.call(window):
			close_app()
			window.place_on_top()
			var move_to: = Vector2((get_viewport().size.x - window.w) / 2 + randf_range(-50, 50), \
										(get_viewport().size.y - window.h) / 2 + randf_range(-50, 50))
			var _tween_0: = get_tree().create_tween()
			_tween_0.tween_property(window, "position", move_to, 
										Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)
			var _tween_1: = get_tree().create_tween()
			_tween_1.tween_property(window, "scale", Vector2(1, 1), 
										Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)
			return

func _return_icons_and_windows() -> void:
	for window_pos in _prev_window_pos_list:
		if not is_instance_valid(window_pos.window):
			continue
			
		var tween_0: = get_tree().create_tween()
		tween_0.tween_property(window_pos.window, "position", window_pos.pos, Consts.TWEEN_TIME_SEC) \
								.set_trans(Tween.TRANS_SINE)
		var tween_1: = get_tree().create_tween()
		tween_1.tween_property(window_pos.window, "scale", Vector2(1, 1), Consts.TWEEN_TIME_SEC) \
								.set_trans(Tween.TRANS_SINE)

	for icon_pos in _prev_icon_pos_list:
		if not is_instance_valid(icon_pos.icon):
			continue

		var tween: = get_tree().create_tween()
		tween.tween_property(icon_pos.icon, "position", icon_pos.pos, Consts.TWEEN_TIME_SEC) \
								.set_trans(Tween.TRANS_SINE)

func _enable_window_buttons() -> void:
	for window in get_tree().get_nodes_in_group("Windows"):
		window.enable_buttons()

func _disable_window_buttons() -> void:
	for window in get_tree().get_nodes_in_group("Windows"):
		window.disable_buttons()

func _scroll_wheel_handle(_delta: float) -> void:
	if not running:
		return

	if Input.is_action_just_released("SCROLL_UP") and not Input.is_action_pressed("KEY_SHIFT"):
		_scroll_bar.scroll(- Consts.SCROLL_SPEED_PX_SEC * _delta)

	if Input.is_action_just_released("SCROLL_DOWN") and not Input.is_action_pressed("KEY_SHIFT"):
		_scroll_bar.scroll(+ Consts.SCROLL_SPEED_PX_SEC * _delta)
