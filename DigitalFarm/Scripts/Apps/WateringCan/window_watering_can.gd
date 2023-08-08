extends WindowWrapper

var filled: = false:
	set(val):
		filled = val 
		print("A")
		if filled:
			$Window/WateringCanEmpty.hide()
			$Window/WateringCanFilled.show()
		else:
			$Window/WateringCanEmpty.show()
			$Window/WateringCanFilled.hide()

func _process(_delta):
	var released_on_window = $Window.released_on_window()
	if released_on_window == null:
		return

	if released_on_window.window_wrapper.app != App_Pot:
		return

	filled = false
