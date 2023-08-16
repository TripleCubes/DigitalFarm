@tool
extends Node2D

func _draw():
	var color_line: = Colors.COLOR_LINE_DAY
	draw_rect(Rect2(0, 0, 2, 2), color_line, true)
