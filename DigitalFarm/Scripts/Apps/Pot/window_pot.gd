extends WindowWrapper

const WATER_REQUEST_TIME_SEC: float = 25
const DEBUG_WATER_REQUEST_TIME_SEC: float = 3

var _time_until_need_water_sec: float = 0
var _show_pot_mini: = false

func requesting_water():
	return pot_status == App_Pot.PotStatus.HAS_SEED \
			and _time_until_need_water_sec < 0

func water() -> void:
	if pot_status != App_Pot.PotStatus.HAS_SEED:
		return

	if not Settings.debug_mode:
		_time_until_need_water_sec = WATER_REQUEST_TIME_SEC
	else:
		_time_until_need_water_sec = DEBUG_WATER_REQUEST_TIME_SEC

	$Window/ProgressBar.paused = false
	$Window/Bubble_NeedWater.hide()

var pot_status: = App_Pot.PotStatus.EMPTY:
	set(val):
		match val:
			App_Pot.PotStatus.EMPTY:
				_show_only_sprite("Sprite_PotEmpty")

			App_Pot.PotStatus.HAS_SEED:
				_show_only_sprite("Sprite_PotHasSeed")
				_progress_bar_activate()

			App_Pot.PotStatus.GROWN:
				_show_only_sprite("Sprite_PotGrown")
				_progress_bar_finished()

			App_Pot.PotStatus.DEAD:
				_show_only_sprite("Sprite_PotDead")
				_progress_bar_finished()

		pot_status = val

func _process(_delta):
	_pot_status_handle(_delta)
	_garden_handle()
	_pot_mini_handle()

func _pot_status_handle(_delta: float) -> void:
	if pot_status == App_Pot.PotStatus.HAS_SEED:
		_time_until_need_water_sec -= _delta
		if _time_until_need_water_sec < 0:
			$Window/ProgressBar.paused = true
			$Window/Bubble_NeedWater.show()

		if $Window/ProgressBar.progress >= 1:
			pot_status = App_Pot.PotStatus.GROWN

func _garden_handle() -> void:	
	var window_check = GlobalFunctions.cursor_inside_of_window($Window)

	if $Window.just_released() and _show_pot_mini:
		var pot_spot: = GlobalFunctions.cursor_on_draw_window_in(window_check, "pot_spot_list")
		if pot_spot != null and not pot_spot.has_pot:
			pot_spot.put_window($Window)
			queue_free()

	_show_pot_mini = $Window.window_dragged_into_app(App_Garden)

func _pot_mini_handle() -> void:
	if not _show_pot_mini:
		$PotMini.hide()
		$Window.show()
		return

	$PotMini.show()
	$Window.hide()

	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	$PotMini.position.x = mouse_pos.x
	$PotMini.position.y = mouse_pos.y

func _show_only_sprite(sprite_name: String) -> void:
	for node in $Window.get_children():
		if not node is Sprite2D:
			continue
		node.hide()

	for node in $PotMini.get_children():
		if not node is Sprite2D:
			continue
		node.hide()

	$Window.get_node(sprite_name).show()
	$PotMini.get_node(sprite_name).show()

func _progress_bar_activate() -> void:
	$Window/ProgressBar.show()
	$Window/ProgressBar.paused = false
	if not Settings.debug_mode:
		_time_until_need_water_sec = WATER_REQUEST_TIME_SEC
	else:
		_time_until_need_water_sec = DEBUG_WATER_REQUEST_TIME_SEC

func _progress_bar_finished() -> void:
	$Window/ProgressBar.hide()
	$Window/ProgressBar.paused = true
