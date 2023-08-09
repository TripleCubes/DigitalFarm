extends Node2D

func _process(_delta):
	ButtonUpdater._update(_delta)

	if Input.is_action_just_pressed("KEY_1"):
		ButtonUpdater.toggle_draw_button_debug_frame()
