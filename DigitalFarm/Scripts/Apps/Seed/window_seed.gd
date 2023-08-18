extends WindowWrapper

func _process(_delta):
	_put_seed_handle()
	_garden_handle()

func _put_seed_handle() -> void:
	var released_on_window = window.released_on_window()

	if released_on_window == null:
		return
	
	if released_on_window.app != App_Pot:
		return

	if released_on_window.window_wrapper.pot_status != App_Pot.PotStatus.EMPTY:
		return

	released_on_window.window_wrapper.put_seed()
	queue_free()

func _garden_handle() -> void:
	var window_check = GlobalFunctions.cursor_inside_of_window_ignore($Window)

	if $Window.just_released() and $MiniIcon.show_mini_icon:
		var pot_spot: = GlobalFunctions.cursor_on_drag_window_in(window_check, "pot_spot_list")
		
		if pot_spot == null:
			return

		if not pot_spot.has_pot:
			return

		if pot_spot.contain_window.window_wrapper.pot_status != App_Pot.PotStatus.EMPTY:
			return

		pot_spot.contain_window.window_wrapper.put_seed()
		queue_free()

	$MiniIcon.show_mini_icon = $Window.window_dragged_into_app(App_Garden)
