extends WindowWrapper

const _pot_spot_scene: PackedScene = preload("res://Scenes/Apps/Garden/pot_spot.tscn")
var pot_spot_list: = []

func _ready():
	for x in 6:
		for y in 6:
			var pot_spot: = _pot_spot_scene.instantiate()
			pot_spot.position.x = 30 + x * 60
			pot_spot.position.y = 30 + y * 60
			pot_spot.window_clip = $Window/UI_WindowClip
			pot_spot.window = $Window
			$Window/UI_WindowClip.add_child(pot_spot)
			pot_spot_list.append(pot_spot)

	$Window.set_button_list()
