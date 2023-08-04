extends Node2D

func _process(_delta):
	ButtonUpdater._update(_delta)

	if Input.is_action_just_pressed("KEY_1"):
		ButtonUpdater.toggle_draw_button_debug_frame()

	# if Input.is_action_just_pressed("KEY_3"):
	# 	var tween: = self.create_tween()
	# 	tween.tween_property($Window, "position", Vector2(100, 100), 0.4).set_trans(Tween.TRANS_SINE)
