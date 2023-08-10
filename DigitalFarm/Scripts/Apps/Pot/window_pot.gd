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
				$Window/Sprite_PotEmpty.show()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.hide()
			App_Pot.PotStatus.HAS_SEED:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.show()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.hide()

				$Window/ProgressBar.show()
				$Window/ProgressBar.paused = false
				if not Settings.debug_mode:
					_time_until_need_water_sec = WATER_REQUEST_TIME_SEC
				else:
					_time_until_need_water_sec = DEBUG_WATER_REQUEST_TIME_SEC
			App_Pot.PotStatus.GROWN:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.show()
				$Window/Sprite_PotDead.hide()

				$Window/ProgressBar.hide()
				$Window/ProgressBar.paused = true
			App_Pot.PotStatus.DEAD:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.show()

				$Window/ProgressBar.hide()
				$Window/ProgressBar.paused = true
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
	if $Window.holding_bar() and window_check != null and window_check.app == App_Garden:
		_show_pot_mini = true

	if $Window.just_released() and window_check != null and window_check.app == App_Garden:
		var pot_spot: = _cursor_on_pot_spot(window_check)
		if pot_spot != null and not pot_spot.has_pot:
			pot_spot.put_window($Window)
			queue_free()

	if window_check == null or window_check.app != App_Garden:
		_show_pot_mini = false		

	if $Window.just_released():
		_show_pot_mini = false

func _cursor_on_pot_spot(window_check: Node2D) -> UI_DragWindowIn:
	for pot_spot in window_check.window_wrapper.pot_spot_list:
		if pot_spot.hovered():
			return pot_spot
	
	return null

func _pot_mini_handle() -> void:
	if not _show_pot_mini:
		$PotMini.hide()
		$Window.show()
		return

	$PotMini.show()
	$Window.hide()

	var mouse_pos: = get_global_mouse_position()
	$PotMini.position.x = mouse_pos.x
	$PotMini.position.y = mouse_pos.y
