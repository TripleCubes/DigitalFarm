extends WindowWrapper

func _process(_delta):
	var released_on_window = window.released_on_window()

	if released_on_window == null:
		return
	
	if released_on_window.app != App_Pot:
		return

	if released_on_window.window_wrapper.pot_status != App_Pot.PotStatus.EMPTY:
		return

	released_on_window.window_wrapper.pot_status = App_Pot.PotStatus.HAS_SEED
	queue_free()
