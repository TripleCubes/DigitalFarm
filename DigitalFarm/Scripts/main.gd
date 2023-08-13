extends Node2D

func _ready():
	Input.set_custom_mouse_cursor(preload("res://Assets/Sprites/UI/cursor_pointer.png"))

func _process(_delta):
	ButtonUpdater._before_update(_delta)
	ButtonUpdater._update(_delta)

	if Input.is_action_just_pressed("KEY_1"):
		ButtonUpdater.toggle_draw_button_debug_frame()
