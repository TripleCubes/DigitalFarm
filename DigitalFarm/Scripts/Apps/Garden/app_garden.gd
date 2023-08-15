extends App

enum CardType {
	TABLE_01X01,
}

func _ready():
	_window_wrapper_scene = preload("res://Scenes/Apps/Garden/window_garden.tscn")
	max_num_windows = 1
