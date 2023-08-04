extends Node

var button_list: = []
var _button_pressed: = false
var _draw_button_debug_frame_enabled: = false

func add_button(button: UI_Button) -> void:
	button_list.append(button)

func _update(_delta) -> void:
	_button_pressed = false
	for i in range(button_list.size() - 1, -1, -1):
		button_list[i]._update(_delta)
		if _button_pressed:
			break

func mark_button_pressed() -> void:
	_button_pressed = true

func toggle_draw_button_debug_frame() -> void:
	if _draw_button_debug_frame_enabled:
		for button in button_list:
			button.draw_debug_frame = false
		_draw_button_debug_frame_enabled = false
	else:
		for button in button_list:
			button.draw_debug_frame = true
		_draw_button_debug_frame_enabled = true
