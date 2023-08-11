extends Node2D

func _ready():
	$Sprite2D.material.set_shader_parameter("color_count", Colors.ColorIndex.size())

	var day_color_list: = []
	var night_color_list: = []
	for i in Colors.ColorIndex.size():
		day_color_list.append(Colors.color_list[i].day)
		night_color_list.append(Colors.color_list[i].night)

	$Sprite2D.material.set_shader_parameter("day_color_list", day_color_list)
	$Sprite2D.material.set_shader_parameter("night_color_list", night_color_list)

func _process(_delta):
	$Sprite2D.material.set_shader_parameter("at_night_float", DayNightCycle.at_night_float)
