@tool
class_name UI_Box
extends Node2D

@export var w: float:
	set(val):
		w = val
		queue_redraw()

@export var h: float:
	set(val):
		h = val
		queue_redraw()

func _draw():
	var draw_w: = w
	var draw_h: = h

	var color_line: = Colors.COLOR_LINE_DAY
	var color_background: = Colors.COLOR_BACKGROUND_DAY

	draw_rect(Rect2(0, 0, w, h), color_background, true)

	# Top
	draw_rect(Rect2(2,      -2,     draw_w - 4, 2         ), color_line, true)
	# Bottom
	draw_rect(Rect2(2,      draw_h, draw_w - 4, 2         ), color_line, true)
	# Left
	draw_rect(Rect2(-2,     2,      2,          draw_h - 4), color_line, true)
	# Right
	draw_rect(Rect2(draw_w, 2,      2,          draw_h - 4), color_line, true)

	# Top left
	draw_rect(Rect2(0, 0, 2, 2), color_line, true)
	# Top right
	draw_rect(Rect2(draw_w - 2, 0, 2, 2), color_line, true)
	# Bottom left
	draw_rect(Rect2(0, draw_h - 2, 2, 2), color_line, true)
	# Bottom right
	draw_rect(Rect2(draw_w - 2, draw_h - 2, 2, 2), color_line, true)
