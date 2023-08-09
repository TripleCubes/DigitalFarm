extends App

const PADDING_LEFT: float = 10
const PADDING_RIGHT: float = 10
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

func run_app() -> void:
	if _running:
		return

	if get_tree().get_nodes_in_group("Windows").size() == 0:
		return

	_update_prev_pos_lists()
	var _cursor_y = _move_icon_and_windows(true)
	_scroll_bar.show()
	_scroll_bar.set_page_length(_cursor_y + PADDING_BOTTOM, get_viewport().size.y)

	_running = true

func close_app() -> void:
	if not _running:
		return
		
	_running = false

func _ready():
	for icon in get_node("/root/Main/IconList").get_children():
		_initial_icon_order.append(icon)

	_scroll_bar.length = get_viewport().size.y
	_scroll_bar.width = 20
	_scroll_bar.position.x = get_viewport().size.x - 20
	_scroll_bar.hide()
	add_child(_scroll_bar)

func _process(_delta):
	if _scroll_bar.scrolling():
		_move_icon_and_windows(false)

func _update_prev_pos_lists() -> void:
	for window in get_tree().get_nodes_in_group("Windows"):
		_prev_window_pos_list.append({
			window = window,
			pos = Vector2(window.position.x, window.position.y),
		})
	for icon in _initial_icon_order:
		_prev_icon_pos_list.append({
			icon = icon,
			pos = Vector2(icon.position.x, icon.position.y),
		})

func _move_icon_and_windows(tween: bool) -> float:
	var _cursor_x: float = WINDOW_PADDING_LEFT
	var _cursor_y: float = PADDING_TOP + _scroll_bar.get_scrolled_pixel()

	for icon in _initial_icon_order:
		if tween:
			var _tween_0: = get_tree().create_tween()
			_tween_0.tween_property(icon, "position", Vector2(PADDING_LEFT, _cursor_y), 
										Consts.POS_TWEEN_TIME).set_trans(Tween.TRANS_SINE)
		else:
			icon.position.x = PADDING_LEFT
			icon.position.y = _cursor_y

		var app_name: AppNames.Name = icon.app_name
		var max_window_h: float = 0
		for window in get_tree().get_nodes_in_group("Windows"):
			if window.app != AppNames.app_list[app_name]:
				continue

			if _cursor_x + window.w > get_viewport().size.x - PADDING_RIGHT:
				_cursor_x = WINDOW_PADDING_LEFT
				_cursor_y += max_window_h / 2 + WINDOW_SPACING_V
				max_window_h = 0

			if tween:
				var _tween_1: = get_tree().create_tween()
				_tween_1.tween_property(window, "position", Vector2(_cursor_x, _cursor_y + window.BAR_HEIGHT/2), 
										Consts.POS_TWEEN_TIME).set_trans(Tween.TRANS_SINE)
				var _tween_2: = get_tree().create_tween()
				_tween_2.tween_property(window, "scale", Vector2(0.501, 0.501), 
										Consts.POS_TWEEN_TIME).set_trans(Tween.TRANS_SINE)
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
	
	return _cursor_y
