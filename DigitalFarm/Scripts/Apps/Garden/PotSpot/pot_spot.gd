@tool
extends UI_DragWindowIn

@onready var _window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "WindowWrapperList")
@onready var _hidden_window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "HiddenWindowWrapperList")

var contain_window: Node2D = null:
	set(val):
		contain_window = val

		if contain_window == null:
			_hide_all_pot_sprites()
			return

		match contain_window.window_wrapper.pot_status:
			App_Pot.PotStatus.EMPTY:
				_show_only_pot_sprite("Sprite_PotEmpty")
			App_Pot.PotStatus.HAS_SEED:
				_show_only_pot_sprite("Sprite_PotHasSeed")
			App_Pot.PotStatus.GROWN:
				_show_only_pot_sprite("Sprite_PotGrown")
			App_Pot.PotStatus.DEAD:
				_show_only_pot_sprite("Sprite_PotDead")				

var has_pot: bool:
	get:
		return contain_window != null

func put_window(in_window: Node2D) -> void:
	contain_window = in_window
	contain_window.hide()
	_window_wrapper_list.remove_child(contain_window.window_wrapper)
	_hidden_window_wrapper_list.add_child(contain_window.window_wrapper)

func _process(_delta):
	if Engine.is_editor_hint():
		return
	
	_throw_window_when_pressed()
	_bubble_need_water_handle()

func _throw_window_when_pressed() -> void:
	if not (just_pressed() and has_pot):
		return

	_hidden_window_wrapper_list.remove_child(contain_window.window_wrapper)
	_window_wrapper_list.add_child(contain_window.window_wrapper)
	contain_window.show()
	window.throw_window_out(contain_window)
	contain_window = null

func _hide_all_pot_sprites() -> void:
	for node in $PotMini.get_children():
		if not node is Sprite2D:
			continue
		node.hide()

func _show_only_pot_sprite(sprite_name: String) -> void:
	_hide_all_pot_sprites()
	$PotMini.get_node(sprite_name).show()

func _bubble_need_water_handle() -> void:
	if contain_window == null:
		$Bubble_NeedWater.hide()
		return

	if not contain_window.window_wrapper.requesting_water():
		$Bubble_NeedWater.hide()
		return

	$Bubble_NeedWater.show()
