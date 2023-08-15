@tool
extends WindowWrapper

const PADDING_TOP: float = 30
const PADDING_BOTTOM: float = 80
const PADDING_LEFT: float = 30
const PADDING_RIGHT: float = 30
const TILE_W: float = 40
const TILE_H: float = 40

const CONTENT_PATH: String = "Window/WindowClip/WindowClipContent/"
@onready var tile_selection = get_node(CONTENT_PATH + "TileSelection")

var pot_spot_list: = {}

func _ready():
	$Window.signal_resize.connect(_window_resized)

	if Engine.is_editor_hint():
		return

	tile_selection.w = TILE_W
	tile_selection.h = TILE_H

func _process(_delta):
	if Engine.is_editor_hint():
		return

	var mouse_pos: Vector2 = GlobalFunctions.get_mouse_pos() - $Window.position
	mouse_pos.x -= $Window/ScrollBarHorizontal.get_scrolled_pixel()
	mouse_pos.y -= $Window/ScrollBarVertical.get_scrolled_pixel()

	_tile_selection_handle(mouse_pos)
	_place_handle(mouse_pos)

func _tile_selection_handle(mouse_pos: Vector2) -> void:
	if _mouse_in_grid(mouse_pos):
		tile_selection.show()
		var selection_pos: = _get_tile_xy_pixel(mouse_pos)
		tile_selection.position.x = selection_pos.x
		tile_selection.position.y = selection_pos.y
	else:
		tile_selection.hide()

func _place_handle(mouse_pos: Vector2) -> void:
	if not _mouse_in_grid(mouse_pos) or not Input.is_action_just_pressed("MOUSE_LEFT"):
		return

	if $Window/CardList.selected_card == null:
		return

	var tile_xy: = _get_tile_xy(mouse_pos)
	var tile_xy_pixel: = _get_tile_xy_pixel(mouse_pos)

	if pot_spot_list.has(tile_xy):
		return

	pot_spot_list[tile_xy] = $Window/CardList.selected_card.get_scene().instantiate()
	var pot_spot = pot_spot_list[tile_xy]
	pot_spot.position.x = tile_xy_pixel.x + TILE_W / 2 - pot_spot.w / 2
	pot_spot.position.y = tile_xy_pixel.y + TILE_H / 2 - pot_spot.h / 2
	_place_pot_spot(pot_spot)

func _place_pot_spot(pot_spot: UI_DragWindowIn) -> void:
	pot_spot.window_clip = $Window/WindowClip
	pot_spot.window = $Window
	$Window/WindowClip/WindowClipContent.add_child(pot_spot)
	$Window.set_button_list()

func _mouse_in_grid(mouse_pos: Vector2) -> bool:
	var grid_wh: = _get_grid_wh()
	return mouse_pos.x > PADDING_LEFT and mouse_pos.y > PADDING_TOP \
			and mouse_pos.x <= PADDING_LEFT + grid_wh.x * TILE_W \
			and mouse_pos.y <= PADDING_TOP + grid_wh.y * TILE_H \
			and $Window.content_hovered()

func _get_grid_wh() -> Vector2i:
	return Vector2i(floor(($Window.max_w - PADDING_LEFT - PADDING_RIGHT) / TILE_W),
						floor(($Window.max_h - PADDING_TOP - PADDING_BOTTOM) / TILE_H))

func _get_tile_xy_pixel(mouse_pos: Vector2) -> Vector2:
	var tile_xy: = _get_tile_xy(mouse_pos)
	return Vector2(tile_xy.x * TILE_W + PADDING_LEFT, tile_xy.y * TILE_H + PADDING_TOP)

func _get_tile_xy(mouse_pos: Vector2) -> Vector2i:
	var result: = Vector2i(0, 0)
	result.x = floor((mouse_pos.x - PADDING_LEFT) / TILE_W)
	result.y = floor((mouse_pos.y - PADDING_TOP) / TILE_H)
	return result

func _window_resized() -> void:
	$Window/CardList.position.y = $Window.h - 68
