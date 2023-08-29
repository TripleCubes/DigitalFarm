extends Node

enum Name {
	POT,
	WATERING_CAN,
	TAP,
	VALLEY,
	SEED,
	SHOW_ALL_APPS,
	GARDEN,
	DOWNLOADS,
}

var app_list: = {}

func _ready():
	app_list[Name.POT] = App_Pot
	app_list[Name.WATERING_CAN] = App_WateringCan
	app_list[Name.TAP] = App_Tap
	app_list[Name.VALLEY] = App_Valley
	app_list[Name.SEED] = App_Seed
	app_list[Name.SHOW_ALL_APPS] = App_ShowAllApps
	app_list[Name.GARDEN] = App_Garden
	app_list[Name.DOWNLOADS] = App_Downloads
