@tool
extends UI_DragWindowIn

@onready var _window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "WindowWrapperList")
@onready var _hidden_window_wrapper_list: = get_node(Consts.MAIN_NODE_PATH + "HiddenWindowWrapperList")

var contain_window: Node2D = null:
	set(val):
		if contain_window != null:
			contain_window.window_wrapper.signal_pot_status_changed.disconnect(_set_pot_sprite)
		contain_window = val

		if contain_window == null:
			_hide_all_pot_sprites()
			$ProgressBar.hide()
			return

		_set_pot_sprite()
		contain_window.window_wrapper.signal_pot_status_changed.connect(_set_pot_sprite)
		$ProgressBar.connected_to = contain_window.get_node("ProgressBar")

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

func _set_pot_sprite() -> void:
	match contain_window.window_wrapper.pot_status:
		App_Pot.PotStatus.EMPTY:
			_show_only_pot_sprite("Sprite_PotEmpty")
			$ProgressBar.hide()

		App_Pot.PotStatus.HAS_SEED:
			_show_only_pot_sprite("Sprite_PotHasSeed")
			$ProgressBar.show()

		App_Pot.PotStatus.GROWN:
			_show_only_pot_sprite("Sprite_PotGrown")
			$ProgressBar.hide()

		App_Pot.PotStatus.DEAD:
			_show_only_pot_sprite("Sprite_PotDead")		
			$ProgressBar.hide()

func _bubble_need_water_handle() -> void:
	if contain_window == null:
		$Bubble_NeedWater.hide()
		return

	if not contain_window.window_wrapper.requesting_water():
		$Bubble_NeedWater.hide()
		return

	$Bubble_NeedWater.show()
