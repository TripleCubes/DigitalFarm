extends Node

enum Name {
	POT,
	WATERING_CAN,
}

var app_list: = {}

func _ready():
	app_list[Name.POT] = App_Pot
