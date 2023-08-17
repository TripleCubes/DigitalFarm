extends WindowWrapper

var filled: = false:
	set(val):
		filled = val 
		if filled:
			$Window/WateringCanEmpty.hide()
			$Window/WateringCanFilled.show()
		else:
			$Window/WateringCanEmpty.show()
			$Window/WateringCanFilled.hide()

func _process(_delta):
	_watering_handle()
	_garden_handle()

func _watering_handle() -> void:
	if not filled:
		return
		
	var released_on_window = $Window.released_on_window()
	if released_on_window == null:
		return

	if released_on_window.app != App_Pot:
		return

	if not released_on_window.window_wrapper.requesting_water():
		return

	released_on_window.window_wrapper.water()
	filled = false

func _garden_handle() -> void:
	if not filled:
		return
		
	var window_check = GlobalFunctions.cursor_inside_of_window_ignore($Window)

	if $Window.just_released() and $MiniIcon.show_mini_icon:
		var pot_spot: = GlobalFunctions.cursor_on_drag_window_in(window_check, "pot_spot_list")
		
		if pot_spot == null:
			return
		
		if not pot_spot.has_pot:
			return

		if not pot_spot.contain_window.window_wrapper.requesting_water():
			return

		pot_spot.contain_window.window_wrapper.water()
		window_check.throw_window_out($Window)

	$MiniIcon.show_mini_icon = $Window.window_dragged_into_app(App_Garden)
