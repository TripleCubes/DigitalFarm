@tool
extends UI_DragWindowIn

var has_pot: bool:
	set(val):
		has_pot = val

		if not has_node("PotMini"):
			return

		if has_pot:
			$PotMini.show()
		else:
			$PotMini.hide()

func put_window(_window: Node2D) -> void:
	has_pot = true

func _process(_delta):
	if just_pressed() and has_pot:
		var _window = App_Pot.run_app()
		window.throw_window_out(_window)
		has_pot = false
