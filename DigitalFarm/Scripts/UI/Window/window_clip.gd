@tool
class_name UI_WindowClip
extends ScrollContainer

@export var content_match_window_size: bool

@export var content_w: float:
	set(val):
		content_w = val
	get:
		if content_match_window_size:
			return window.max_w
		return content_w

@export var content_h: float:
	set(val):
		content_h = val
	get:
		if content_match_window_size:
			return window.max_h
		return content_h

@onready var window: = get_parent()

func _ready():
	clip_contents = true
	add_child(Control.new())

func _draw():
	if not Engine.is_editor_hint():
		return

	if content_match_window_size:
		return

	draw_rect(Rect2(0, 0, content_w, content_h), Color("99fff8"), false)

func _process(_delta):
	self.size.x = window.w
	self.size.y = window.h

	if Engine.is_editor_hint():
		clip_contents = false
	else:
		clip_contents = true

	queue_redraw()
