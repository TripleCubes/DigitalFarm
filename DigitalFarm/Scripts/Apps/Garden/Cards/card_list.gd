extends Node2D

const CARD_SPACING: float = 4
const SELECTED_CARD_UP_OFFSET: float = 8
const SELECTED_CARD_TWEEN_TIME: float = 0.15

const _card_scene: PackedScene = preload("res://Scenes/Apps/Garden/card.tscn")

@onready var window_wrapper: = get_parent().get_parent()

var selected_card: Node2D:
	set(val):
		selected_card = val

		if selected_card.card_type == App_Garden.CardType.REMOVE:
			window_wrapper.disable_all_pot_spots()
		else:
			window_wrapper.enable_all_pot_spots()

		_reposition_cards(true, SELECTED_CARD_TWEEN_TIME)

		var tween_0 = get_tree().create_tween()
		tween_0.tween_property(selected_card, "position", 
								Vector2(selected_card.position.x, - SELECTED_CARD_UP_OFFSET),
								SELECTED_CARD_TWEEN_TIME).set_trans(Tween.TRANS_SINE)

var card_list: = []

func _ready():
	_add_card(App_Garden.CardType.TABLE_01X01)
	_add_card(App_Garden.CardType.REMOVE)

	_reposition_cards(false, Consts.TWEEN_TIME_SEC)

func _add_card(card_type: App_Garden.CardType) -> void:
	var card = _card_scene.instantiate()
		
	card.card_list = self
	card.window_wrapper = get_parent().get_parent()
	card.window = get_parent().get_parent().get_parent()
	card.card_type = card_type

	card_list.append(card)
	add_child(card)

func _reposition_cards(tween: bool, tween_time: float) -> void:
	for i in card_list.size():
		var card = card_list[i]
		if tween:
			var tween_0 = get_tree().create_tween()
			tween_0.tween_property(card, "position", Vector2(i * (card.w + CARD_SPACING), 0),
									tween_time).set_trans(Tween.TRANS_SINE)
		else:
			card.position.x = i * (card.w + CARD_SPACING)

	_set_prevent_click_through_button_size()

func _set_prevent_click_through_button_size() -> void:
	if card_list.size() == 0:
		$Button_PreventClickthrough.w = 10
		return

	var card_w = card_list[0].w
	$Button_PreventClickthrough.w = card_list.size() * (card_w + CARD_SPACING) - CARD_SPACING*2
