@tool
extends Node2D

const _font: = preload("res://Assets/Fonts/Munro/munro.ttf")

@onready var _download_item_list = get_parent()
@onready var _original_box_h = $Box.h

@export var icon: Texture2D:
	set(val):
		icon = val
		$Box/Icon.texture = icon

@export var title: String:
	set(val):
		title = val
		$Box/Title.text = title

@export_multiline var more_info: String:
	set(val):
		more_info = val
		$Box/ClipContent/Node2D/MoreInfo.text = more_info

@export var app_name: AppNames.Name

var h: float:
	get: 
		if expanded: 
			var more_info_label: UI_Text = $Box/ClipContent/Node2D/MoreInfo
			var text_h: = _font.get_multiline_string_size(more_info_label.text,
															HORIZONTAL_ALIGNMENT_LEFT,
															more_info_label.size.x,
															20).y + 7
			return _original_box_h + text_h

		return _original_box_h

var expanded: bool:
	set(val):
		expanded = val
		if expanded:
			$Box/Button_More.hide()
			$Box/Button_Less.show()

			var more_info_label: UI_Text = $Box/ClipContent/Node2D/MoreInfo
			var text_h: = _font.get_multiline_string_size(more_info_label.text,
															HORIZONTAL_ALIGNMENT_LEFT,
															more_info_label.size.x,
															20).y + 7

			var tween: = get_tree().create_tween()
			tween.tween_property($Box, "h", _original_box_h + text_h, 0.3).set_trans(Tween.TRANS_SINE)

			var tween_0: = get_tree().create_tween()
			tween_0.tween_property($Box/ClipContent, "size", Vector2(170, _original_box_h + text_h), 0.3).set_trans(Tween.TRANS_SINE)

			_download_item_list.rearrange(true)
		
		else:
			$Box/Button_More.show()
			$Box/Button_Less.hide()

			var tween: = get_tree().create_tween()
			tween.tween_property($Box, "h", _original_box_h, 0.3).set_trans(Tween.TRANS_SINE)

			var tween_0: = get_tree().create_tween()
			tween_0.tween_property($Box/ClipContent, "size", Vector2(170, _original_box_h), 0.3).set_trans(Tween.TRANS_SINE)

			_download_item_list.rearrange(true)

func setup_button_window_clips(window_clip: UI_WindowClip) -> void:
	$Box/Button_Download.window_clip = window_clip
	$Box/Button_Delete.window_clip = window_clip
	$Box/Button_Less.window_clip = window_clip
	$Box/Button_More.window_clip = window_clip

func _ready():
	if AppNames.app_list[app_name].downloaded():
		$Box/Button_Download.hide()
		$Box/Button_Delete.show()

func _process(_delta):
	if $Box/Button_More.just_pressed():
		expanded = true

	if $Box/Button_Less.just_pressed():
		expanded = false

	if $Box/Button_Download.just_pressed():
		$Box/Button_Download.hide()
		$Box/Button_Delete.show()

		if app_name != null:
			AppNames.app_list[app_name].download_app()

	if $Box/Button_Delete.just_pressed():
		$Box/Button_Download.show()
		$Box/Button_Delete.hide()

		if app_name != null:
			AppNames.app_list[app_name].delete_app()
