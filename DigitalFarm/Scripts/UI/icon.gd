@tool
extends Node2D

@export var app_name: AppNames.Name
@export var texture: Texture2D

var _prev_x: float = 0
var _prev_y: float = 0
var _prev_mouse_x: float = 0
var _prev_mouse_y: float = 0

func _ready():
	$Button.texture = texture

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if App_ShowAllApps.running:
		return

	if Input.is_action_just_pressed("MOUSE_LEFT"):
		_prev_x = self.global_position.x
		_prev_y = self.global_position.y
		var mouse_pos: = get_global_mouse_position()
		_prev_mouse_x = mouse_pos.x
		_prev_mouse_y = mouse_pos.y

	if $Button.just_pressed():
		move_to_front()
		$Button.place_on_top()
	_move_icon()
	_double_click_handle()

func _move_icon() -> void:
	var mouse_pos: = get_global_mouse_position()

	if $Button.pressed():
		self.global_position.x = _prev_x + (mouse_pos.x - _prev_mouse_x)
		self.global_position.y = _prev_y + (mouse_pos.y - _prev_mouse_y)

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

func _double_click_handle() -> void:
	if app_name == null:
		return

	if $Button.double_clicked():
		AppNames.app_list[app_name].run_app()
