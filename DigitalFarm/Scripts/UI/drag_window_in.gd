@tool
class_name UI_DragWindowIn
extends Node2D

@export var w: float:
	set(val):
		button.w = val
		w = val
@export var h: float:
	set(val):
		button.h = val
		h = val
@export var draw_debug_frame: bool:
	set(val):
		button.draw_debug_frame = val
		draw_debug_frame = val

var window_clip: UI_WindowClip:
	set(val):
		button.window_clip = val

var enabled: = true:
	set(val):
		button.enabled = val
	get:
		return button.enabled

var window: Node2D

var button: = UI_Button.new()

func hovered() -> bool:
	return button.hovered()

func just_pressed() -> bool:
	return button.just_pressed()

func _ready():
	self.add_to_group("DragWindowIns")
	add_child(button)
