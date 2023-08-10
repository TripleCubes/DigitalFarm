extends Node

var button_dict: = {}
var button_z_list: = []
var _button_pressed: = false
var draw_button_debug_frame_enabled: = false

func add_button(button: UI_Button) -> void:	
	if not button_dict.has(button.z):
		button_dict[button.z] = []
		button_z_list.append(button.z)

	button_dict[button.z].append(button)

	button_z_list.sort()

func remove_button(button: UI_Button) -> void:
	button_dict[button.z].erase(button)

func place_button_on_top(button: UI_Button) -> void:
	button_dict[button.z].erase(button)
	button_dict[button.z].push_back(button)

func _process(_delta):
	_button_pressed = false

func _update(_delta) -> void:
	for z_list_index in range(button_z_list.size() - 1, -1, -1):
		var z: int = button_z_list[z_list_index]
		for i in range(button_dict[z].size() - 1, -1, -1):
			if button_dict[z][i].is_queued_for_deletion():
				continue
				
			button_dict[z][i]._update(_delta)

			if button_dict[z][i].pressed() or _button_pressed:
				return

func mark_button_pressed() -> void:
	_button_pressed = true

func toggle_draw_button_debug_frame() -> void:
	if draw_button_debug_frame_enabled:
		for z in button_z_list:
			for button in button_dict[z]:
				button.draw_debug_frame = false
		draw_button_debug_frame_enabled = false
	else:
		for z in button_z_list:
			for button in button_dict[z]:
				button.draw_debug_frame = true
		draw_button_debug_frame_enabled = true
