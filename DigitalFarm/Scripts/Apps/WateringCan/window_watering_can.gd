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
