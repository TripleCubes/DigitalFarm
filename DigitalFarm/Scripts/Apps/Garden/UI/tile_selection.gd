extends Node2D

const CORNER_LENGTH: float = 8

var w: float = 10:
	set(val):
		w = val
		queue_redraw()

var h: float = 10:
	set(val):
		h = val
		queue_redraw()

func _draw():
	# Top left
	draw_rect(Rect2(0, 0, 2, CORNER_LENGTH), Colors.COLOR_WHITE, true)
	draw_rect(Rect2(0, 0, CORNER_LENGTH, 2), Colors.COLOR_WHITE, true)
	# Top right
	draw_rect(Rect2(w, 0, - 2, CORNER_LENGTH), Colors.COLOR_WHITE, true)
	draw_rect(Rect2(w, 0, - CORNER_LENGTH, 2), Colors.COLOR_WHITE, true)
	# Bottom left
	draw_rect(Rect2(0, h, 2, - CORNER_LENGTH), Colors.COLOR_WHITE, true)
	draw_rect(Rect2(0, h, CORNER_LENGTH, - 2), Colors.COLOR_WHITE, true)
	# Bottom right
	draw_rect(Rect2(w, h, - 2, - CORNER_LENGTH), Colors.COLOR_WHITE, true)
	draw_rect(Rect2(w, h, - CORNER_LENGTH, - 2), Colors.COLOR_WHITE, true)
