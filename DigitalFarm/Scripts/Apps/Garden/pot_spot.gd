@tool
extends UI_DragWindowIn

@onready var _window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "WindowWrapperList")
@onready var _hidden_window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "HiddenWindowWrapperList")

var contain_window: Node2D = null:
	set(val):
		contain_window = val

		if contain_window == null:
			_hide_all_sprites()
			return

		match contain_window.window_wrapper.pot_status:
			App_Pot.PotStatus.EMPTY:
				_show_only_sprite("Sprite_PotEmpty")
			App_Pot.PotStatus.HAS_SEED:
				_show_only_sprite("Sprite_PotHasSeed")
			App_Pot.PotStatus.GROWN:
				_show_only_sprite("Sprite_PotGrown")
			App_Pot.PotStatus.DEAD:
				_show_only_sprite("Sprite_PotDead")				

var has_pot: bool:
	get:
		return contain_window != null

func put_window(in_window: Node2D) -> void:
	contain_window = in_window
	_window_wrapper_list.remove_child(in_window.window_wrapper)
	_hidden_window_wrapper_list.add_child(in_window.window_wrapper)

func _process(_delta):
	if just_pressed() and has_pot:
		_hidden_window_wrapper_list.remove_child(contain_window.window_wrapper)
		_window_wrapper_list.add_child(contain_window.window_wrapper)
		window.throw_window_out(contain_window)
		contain_window = null

func _hide_all_sprites() -> void:
	for node in $PotMini.get_children():
		if not node is Sprite2D:
			continue
		node.hide()

func _show_only_sprite(sprite_name: String) -> void:
	_hide_all_sprites()
	$PotMini.get_node(sprite_name).show()
