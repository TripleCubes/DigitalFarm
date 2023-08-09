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
		
	for window_comp in get_tree().get_nodes_in_group("Windows"):
		if window_comp.app == null or window_comp.app != App_WateringCan:
			continue

		if window_comp.window_wrapper.filled:
			continue
		
		var wx = window_comp.position.x
		var wy = window_comp.position.y
		var self_wx = $Window.position.x
		var self_wy = $Window.position.y
		if wy > self_wy \
		and GlobalFunctions.box_collision_check(wx, window_comp.w, self_wx + ($Window.w - 10) / 2, 10):
			window_comp.window_wrapper.filled = true
