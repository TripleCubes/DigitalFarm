extends Node2D

var card_type: App_Garden.CardType

var w: float:
	get:
		return $Button.w

var h: float:
	get:
		return $Button.h

var card_list: Node2D
var window_wrapper: Node2D

var sprite_list: = {}
var scene_list: = {}

func get_scene():
	return scene_list[card_type]

func _ready():
	_set_sprite_list()
	_set_scene_list()

func _draw():
	var texture = sprite_list[card_type]
	draw_texture_rect(texture, Rect2(w / 2 - texture.get_width(),
									h / 2 - texture.get_height(),
									texture.get_width() * 2,
									texture.get_height() * 2), false)

func _set_sprite_list() -> void:
	sprite_list[App_Garden.CardType.TABLE_01X01] = preload("res://Assets/Sprites/Apps/Garden/PotSpot/table_mini.png")

func _set_scene_list() -> void:
	scene_list[App_Garden.CardType.TABLE_01X01] = preload("res://Scenes/Apps/Garden/pot_spot.tscn")

func _process(_delta):
	if $Button.just_pressed():
		card_list.selected_card = self
