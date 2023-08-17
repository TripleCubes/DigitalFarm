extends WindowWrapper

var pouring_water: = false

func _process(_delta):
	if $Window/Button_Tap.just_pressed():
		pouring_water = not pouring_water
		if pouring_water:
			$Window/Water.show()
		else:
			$Window/Water.hide()

	if not pouring_water:
		return

	var window_on_top_of_list = _get_window_on_top_of_list()
	for window_comp in window_on_top_of_list:
		if window_comp.app == null:
			continue
		
		if window_comp.app == App_WateringCan:
			window_comp.window_wrapper.filled = true
			continue

		if window_comp.app == App_Pot:
			window_comp.window_wrapper.water()

func _get_window_on_top_of_list() -> Array:
	var result_arr: = []
	for window_comp in get_tree().get_nodes_in_group("Windows"):
		if not window_comp.is_visible_in_tree():
			continue
			
		var wx = window_comp.position.x
		var wy = window_comp.position.y
		var self_wx = $Window.position.x
		var self_wy = $Window.position.y
		if wy > self_wy \
		and GlobalFunctions.box_collision_check(wx, window_comp.w, self_wx + ($Window.w - 10) / 2, 10):
			result_arr.append(window_comp)

	return result_arr
