extends Node2D

@onready var _window_clip: UI_WindowClip = get_parent().get_parent()
@onready var _window: Node2D = _window_clip.get_parent()

const ITEM_SPACING: float = 6
const PADDING_TOP: float = 10
const PADDING_BOTTOM: float = 10

func rearrange(do_tween: bool) -> void:
	var cursor_y: float = PADDING_TOP

	for i in get_child_count():
		var download_item: = get_child(i)

		if do_tween:
			var tween: = get_tree().create_tween()
			tween.tween_property(download_item, "position", Vector2(0, cursor_y), 0.3).set_trans(Tween.TRANS_SINE)

		else:
			download_item.position.y = cursor_y

		cursor_y += ITEM_SPACING + download_item.h + 4
	
	_window_clip.content_h = cursor_y + PADDING_BOTTOM - ITEM_SPACING - 4
	_window.page_length_resize_handle()

func _ready():
	for download_item in get_children():
		download_item.setup_button_window_clips(_window_clip)

	rearrange(false)
