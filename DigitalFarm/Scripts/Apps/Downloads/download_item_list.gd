extends Node2D

@onready var _window_clip: UI_WindowClip = get_parent().get_parent()

func _ready():
	for download_item in get_children():
		download_item.setup_button_window_clips(_window_clip)
