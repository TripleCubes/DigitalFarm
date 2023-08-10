@tool
class_name UI_DragWindowIn
extends Node2D

@export var w: float:
	set(val):
		_button.w = val
		w = val
@export var h: float:
	set(val):
		_button.h = val
		h = val
@export var draw_debug_frame: bool:
	set(val):
		_button.draw_debug_frame = val
		draw_debug_frame = val

var _button: = UI_Button.new()

func hovered() -> bool:
	return _button.hovered()

func just_pressed() -> bool:
	return _button.just_pressed()

func put_window(_window: Node2D) -> void:
	pass

func _ready():
	self.add_to_group("DragWindowIns")
	add_child(_button)
