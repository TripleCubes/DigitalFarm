extends App

enum PotStatus {
	EMPTY,
	HAS_SEED,
	GROWN,
	DEAD,
}

func _ready():
	_window_wrapper_scene = preload("res://Scenes/Apps/Pot/window_pot.tscn")
