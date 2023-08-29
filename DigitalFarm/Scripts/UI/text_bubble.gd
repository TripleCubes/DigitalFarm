@tool
class_name UI_TextBubble
extends Node2D

@onready var _font: = preload("res://Assets/Fonts/Munro/munro.ttf")

const TIME_COUNT_MAX_SEC: float = 7
const MARGIN_LEFT: float = 10
const MARGIN_RIGHT: float = 10
const MARGIN_TOP: float = 5
const MARGIN_BOTTOM: float = 5

enum Dir {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

@export var max_w: float:
	set(val):
		max_w = val
		queue_redraw()

@export var dir: Dir

var _text: = UI_Text.new()
var _time_counter_sec: float = TIME_COUNT_MAX_SEC

func show_text(text: String) -> void:
	_text.show()
	_text.show_text(text)
	_text.show_all_text()
	_time_counter_sec = 0
	queue_redraw()

func _ready():
	_text.size.x = max_w
	_text.size.y = 1000
	_text.position.x = MARGIN_LEFT
	_text.position.y = MARGIN_TOP
	add_child(_text)

func _draw():
	var draw_w: float = 0
	var draw_h: float = 0

	if Engine.is_editor_hint():
		draw_w = max_w
		draw_h = 50
	else:
		var draw_size: = _font.get_multiline_string_size(_text.text, HORIZONTAL_ALIGNMENT_LEFT, max_w, 20)
		draw_w = draw_size.x + MARGIN_LEFT + MARGIN_RIGHT
		draw_h = draw_size.y + MARGIN_TOP + MARGIN_BOTTOM

	if not Engine.is_editor_hint() and _time_counter_sec >= TIME_COUNT_MAX_SEC:
		return
	
	draw_rect(Rect2(0, 0, draw_w, draw_h), Colors.COLOR_BACKGROUND_DAY, true)
	
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
	if Engine.is_editor_hint():
		return

	_time_counter_sec += _delta
	
	if _time_counter_sec >= TIME_COUNT_MAX_SEC and _text.visible:
		_text.hide()
		queue_redraw()
