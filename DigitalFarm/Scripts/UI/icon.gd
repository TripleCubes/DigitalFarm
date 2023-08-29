@tool
extends Node2D

@onready var _icon_bubble_list: = get_node(Consts.MAIN_NODE_PATH + "IconBubbleList")

const TEXT_BUBBLE_TOP_OFFSET: float = 2
const TEXT_BUBBLE_LEFT_OFFSET: float = 10
const TEXT_BUBBLE_WIDTH: float = 300

@export var app_name: AppNames.Name
@export var texture: Texture2D

var _prev_x: float = 0
var _prev_y: float = 0
var _prev_mouse_x: float = 0
var _prev_mouse_y: float = 0

var _text_bubble: = UI_TextBubble.new()

func _ready():
	$Button.texture = texture

	if Engine.is_editor_hint():
		return

	_text_bubble.max_w = TEXT_BUBBLE_WIDTH
	_text_bubble.dir = _text_bubble.Dir.TOP_LEFT
	var dir: = _get_text_bubble_dir()
	_text_bubble.position = _get_text_bubble_pos(self.position, dir)
	_icon_bubble_list.add_child(_text_bubble)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if App_ShowAllApps.running:
		return

	if Input.is_action_just_pressed("MOUSE_LEFT"):
		_prev_x = self.global_position.x
		_prev_y = self.global_position.y
		var mouse_pos: = GlobalFunctions.get_mouse_pos()
		_prev_mouse_x = mouse_pos.x
		_prev_mouse_y = mouse_pos.y

	if $Button.just_pressed():
		move_to_front()
		$Button.place_on_top()
	_move_icon()
	_double_click_handle()

func _move_icon() -> void:
	var mouse_pos: = GlobalFunctions.get_mouse_pos()

	if $Button.pressed():
		self.global_position.x = _prev_x + (mouse_pos.x - _prev_mouse_x)
		self.global_position.y = _prev_y + (mouse_pos.y - _prev_mouse_y)

		var dir: = _get_text_bubble_dir()
		_text_bubble.dir = dir
		_text_bubble.position = _get_text_bubble_pos(self.position, dir)

	if $Button.just_released():
		var move_to: = Vector2(self.position.x, self.position.y)
		if self.position.x < 0:
			move_to.x = 0
		if self.position.y < 0:
			move_to.y = 0
		if self.position.x + $Button.w > get_viewport().size.x:
			move_to.x = get_viewport().size.x - $Button.w
		if self.position.y + $Button.h > get_viewport().size.y:
			move_to.y = get_viewport().size.y - $Button.h

		var _tween: = get_tree().create_tween()
		_tween.tween_property(self, "position", move_to, Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)

		var dir: = _get_text_bubble_dir()
		_text_bubble.dir = dir
		var _tween_0: = get_tree().create_tween()
		_tween_0.tween_property(_text_bubble, "position", _get_text_bubble_pos(move_to, dir), 
									Consts.TWEEN_TIME_SEC).set_trans(Tween.TRANS_SINE)

func _double_click_handle() -> void:
	if app_name == null:
		return

	if $Button.double_clicked():
		AppNames.app_list[app_name].run_app()

func _get_text_bubble_dir() -> UI_TextBubble.Dir:
	if get_viewport().size.x - self.position.x < $Button.w + TEXT_BUBBLE_WIDTH + TEXT_BUBBLE_LEFT_OFFSET:
		return UI_TextBubble.Dir.TOP_RIGHT
	
	return UI_TextBubble.Dir.TOP_LEFT

func _get_text_bubble_pos(icon_pos: Vector2, dir: UI_TextBubble.Dir) -> Vector2:
	if dir == UI_TextBubble.Dir.TOP_LEFT:
		return icon_pos + Vector2($Button.w + TEXT_BUBBLE_LEFT_OFFSET, TEXT_BUBBLE_TOP_OFFSET)

	return icon_pos + Vector2(- TEXT_BUBBLE_WIDTH - TEXT_BUBBLE_LEFT_OFFSET - 16, TEXT_BUBBLE_TOP_OFFSET)
