extends Node2D

@onready var window: Node2D = get_parent()
@onready var window_clip_content = window.get_node_or_null("WindowClip/WindowClipContent")
@onready var window_clip = window.get_node_or_null("WindowClip")

func _ready():
	if window.resizable:
		$ScrollBarVertical.show()
		$ScrollBarHorizontal.show()

func _update(_delta) -> void:
	if window.resizing():
		set_element_locations()
	
	_scroll_window(_delta)

func set_element_locations() -> void:
	if window_clip == null:
		return

	$ScrollBarVertical.position.x = window.w - 15
	$ScrollBarVertical.length = window.h - $ScrollBarVertical.width + 4
	$ScrollBarVertical.set_page_length(window_clip.content_h, window.h)

	$ScrollBarHorizontal.position.y = window.h - 15
	$ScrollBarHorizontal.length = window.w - $ScrollBarHorizontal.width + 4
	$ScrollBarHorizontal.set_page_length(window_clip.content_w, window.w)

func _scroll_window(_delta: float):
	if window_clip_content == null:
		return

	if GlobalFunctions.cursor_inside_of_window() == window and not App_ShowAllApps.running:
		if Input.is_action_just_released("SCROLL_UP") and not Input.is_action_pressed("KEY_SHIFT"):
			$ScrollBarVertical.scroll(- Consts.SCROLL_SPEED_PX_SEC * _delta)

		if Input.is_action_just_released("SCROLL_DOWN") and not Input.is_action_pressed("KEY_SHIFT"):
			$ScrollBarVertical.scroll(+ Consts.SCROLL_SPEED_PX_SEC * _delta)

		if Input.is_action_just_released("SCROLL_LEFT") \
		or (Input.is_action_just_released("SCROLL_UP") and Input.is_action_pressed("KEY_SHIFT")):
			$ScrollBarHorizontal.scroll(- Consts.SCROLL_SPEED_PX_SEC * _delta * 2)

		if Input.is_action_just_released("SCROLL_RIGHT") \
		or (Input.is_action_just_released("SCROLL_DOWN") and Input.is_action_pressed("KEY_SHIFT")):
			$ScrollBarHorizontal.scroll(+ Consts.SCROLL_SPEED_PX_SEC * _delta * 2)

	if $ScrollBarVertical.scrolling() or window.resizing():
		window_clip_content.position.y = $ScrollBarVertical.get_scrolled_pixel()

	if $ScrollBarHorizontal.scrolling() or window.resizing():
		window_clip_content.position.x = $ScrollBarHorizontal.get_scrolled_pixel()
