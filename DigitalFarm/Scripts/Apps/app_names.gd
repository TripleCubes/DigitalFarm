extends Node

enum Name {
	POT,
	WATERING_CAN,
	TAP,
	VALLEY,
}

var app_list: = {}

func _ready():
	app_list[Name.POT] = App_Pot
	app_list[Name.WATERING_CAN] = App_WateringCan
	app_list[Name.TAP] = App_Tap
	app_list[Name.VALLEY] = App_Valley
