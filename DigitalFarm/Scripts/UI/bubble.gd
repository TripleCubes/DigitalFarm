@tool
class_name UI_Bubble
extends Node2D

enum Dir {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

@export var w: float
@export var h: float
@export var init_texture: Texture2D
@export var init_dir: Dir

var texture: Texture2D
var dir: Dir

func _ready():
	texture = init_texture
	dir = init_dir

func _draw():
	var draw_w: = w
	var draw_h: = h
	if w == 0 or h == 0:
		draw_w = texture.get_width() * 2
		draw_h = texture.get_height() * 2

	if texture != null:
		draw_texture_rect(texture, Rect2(0, 0, draw_w, draw_h), false)

	draw_rect(Rect2(0,      -2,     draw_w, 2     ), Color(1, 1, 1))
	draw_rect(Rect2(0,      draw_h, draw_w, 2     ), Color(1, 1, 1))
	draw_rect(Rect2(-2,     0,      2,      draw_h), Color(1, 1, 1))
	draw_rect(Rect2(draw_w, 0,      2,      draw_h), Color(1, 1, 1))

	match dir:
		Dir.TOP_LEFT:
			draw_rect(Rect2(-2, -2, 2, 2), Color(1, 1, 1))
		Dir.TOP_RIGHT:
			draw_rect(Rect2(draw_w, -2, 2, 2), Color(1, 1, 1))
		Dir.BOTTOM_LEFT:
			draw_rect(Rect2(-2, draw_h, 2, 2), Color(1, 1, 1))
		Dir.BOTTOM_RIGHT:
			draw_rect(Rect2(draw_w, draw_h, 2, 2), Color(1, 1, 1))

func _process(_delta):
	queue_redraw()
