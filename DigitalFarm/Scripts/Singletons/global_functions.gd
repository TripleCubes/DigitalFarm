extends Node2D

@onready var viewport: = get_node("/root/Viewport")

func get_mouse_pos() -> Vector2:
	return viewport.get_global_mouse_position()

func get_local_mouse_pos(node: Node2D) -> Vector2:
	var mouse_pos = viewport.get_global_mouse_position()
	return Vector2(mouse_pos.x - node.position.x, mouse_pos.y - node.position.y)

func box_collision_check(x1: float, w1: float, x2: float, w2: float) -> bool:
	if (x1 >= x2 and x1 <= x2 + w2) or (x1 + w1 >= x2 and x1 + w1 <= x2 + w2) \
	or (x2 >= x1 and x2 <= x1 + w1) or (x2 + w2 >= x1 and x2 + w2 <= x1 + w1):
		return true
	return false
	
func windows_overllap(window1: Node2D, window2: Node2D) -> bool:
	var x1: float = window1.position.x
	var y1: float = window1.position.y
	var w1: float = window1.w
	var h1: float = window1.h
	var x2: float = window2.position.x
	var y2: float = window2.position.y
	var w2: float = window2.w
	var h2: float = window2.h
	
	return box_collision_check(x1, w1, x2, w2) \
	and box_collision_check(y1, h1, y2, h2)

func cursor_inside_of_window(ignore_window: Node2D = null) -> Node2D:
	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	var window_list: = get_tree().get_nodes_in_group("Windows")
	for i in range(window_list.size() - 1, -1, -1):
		var window: Node2D = window_list[i]

		if ignore_window != null and ignore_window == window:
			continue
			
		if mouse_pos.x >= window.position.x and mouse_pos.y >= window.position.y \
		and mouse_pos.x <= window.position.x + window.w \
		and mouse_pos.y <= window.position.y + window.h:
			return window

	return null

func cursor_on_draw_window_in(window_check: Node2D, draw_window_in_list_name: String) -> UI_DragWindowIn:
	for draw_window_in in window_check.window_wrapper[draw_window_in_list_name]:
		if draw_window_in.hovered():
			return draw_window_in
	
	return null
