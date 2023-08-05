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
	if $Window.just_released():
		for window in get_tree().get_nodes_in_group("Windows"):
			if window.app == null or window.app != App_Pot:
				continue

			if GlobalFunctions.windows_overllap($Window, window):
				self.filled = false
