@tool
extends Node2D

@export var icon: Texture2D:
	set(val):
		icon = val
		$UI_Box/Icon.texture = icon

@export var title: String:
	set(val):
		title = val
		$UI_Box/Title.text = title

func setup_button_window_clips(window_clip: UI_WindowClip) -> void:
	$UI_Box/DownloadButton.window_clip = window_clip
