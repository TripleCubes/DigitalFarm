@tool
class_name UI_WindowClip
extends ScrollContainer

@onready var window: = get_parent()

func _ready():
	clip_contents = true
	add_child(Control.new())

func _process(_delta):
	self.size.x = window.w
	self.size.y = window.h

	if Engine.is_editor_hint():
		clip_contents = false
	else:
		clip_contents = true
