extends WindowWrapper

const PADDING: float = 30
const TILE_W: float = 40
const TILE_H: float = 40

const CONTENT_PATH: String = "Window/WindowClip/WindowClipContent/"
@onready var tile_selection = get_node(CONTENT_PATH + "TileSelection")

const _pot_spot_scene: PackedScene = preload("res://Scenes/Apps/Garden/pot_spot.tscn")
var pot_spot_list: = []

func _ready():
	# for x in 6:
	# 	for y in 6:
	# 		var pot_spot: = _pot_spot_scene.instantiate()
	# 		pot_spot.position.x = 30 + x * 60
	# 		pot_spot.position.y = 30 + y * 60
	# 		pot_spot.window_clip = $Window/WindowClip
	# 		pot_spot.window = $Window
	# 		$Window/WindowClip/WindowClipContent.add_child(pot_spot)
	# 		pot_spot_list.append(pot_spot)

	tile_selection.w = TILE_W
	tile_selection.h = TILE_H

	$Window.set_button_list()

func _process(_delta):
	var mouse_pos: Vector2 = GlobalFunctions.get_mouse_pos() - $Window.position
	mouse_pos.x -= $Window/ScrollBarHorizontal.get_scrolled_pixel()
	mouse_pos.y -= $Window/ScrollBarVertical.get_scrolled_pixel()

	if _mouse_in_grid(mouse_pos):
		tile_selection.show()
		var selection_pos: = _get_tile_xy(mouse_pos)
		tile_selection.position.x = selection_pos.x
		tile_selection.position.y = selection_pos.y
	else:
		tile_selection.hide()

func _mouse_in_grid(mouse_pos: Vector2) -> bool:
	var grid_wh: = _get_grid_wh()
	return mouse_pos.x > PADDING and mouse_pos.y > PADDING \
			and mouse_pos.x <= PADDING + grid_wh.x * TILE_W \
			and mouse_pos.y <= PADDING + grid_wh.y * TILE_H \
			and $Window.content_hovered()

func _get_grid_wh() -> Vector2i:
	return Vector2i(floor(($Window.max_w - PADDING*2) / TILE_W),
						floor(($Window.max_h - PADDING*2) / TILE_H))

func _get_tile_xy(mouse_pos: Vector2) -> Vector2:
	var result: Vector2 = Vector2(0, 0)
	result.x = floor((mouse_pos.x - PADDING) / TILE_W) * TILE_W + PADDING
	result.y = floor((mouse_pos.y - PADDING) / TILE_H) * TILE_H + PADDING
	return result
