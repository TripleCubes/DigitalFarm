extends WindowWrapper

const _pot_spot_scene: PackedScene = preload("res://Scenes/Apps/Garden/pot_spot.tscn")
var pot_spot_list: = []

func _ready():
	for x in 3:
		for y in 3:
			var pot_spot: = _pot_spot_scene.instantiate()
			pot_spot.position.x = x * 40
			pot_spot.position.y = y * 40
			$Window/UI_WindowClip.add_child(pot_spot)
			pot_spot_list.append(pot_spot)

	$Window.set_button_list()
