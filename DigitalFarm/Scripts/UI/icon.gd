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
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("MOUSE_LEFT"):
			_prev_x = self.global_position.x
			_prev_y = self.global_position.y
			var mouse_pos: = get_global_mouse_position()
			_prev_mouse_x = mouse_pos.x
			_prev_mouse_y = mouse_pos.y

		if $Button.just_pressed():
			move_to_front()
		_move_icon()
		_double_click_handle()

func _move_icon() -> void:
	var mouse_pos: = get_global_mouse_position()

	if not $Button.pressed():
		return

	self.global_position.x = _prev_x + (mouse_pos.x - _prev_mouse_x)
	self.global_position.y = _prev_y + (mouse_pos.y - _prev_mouse_y)

func _double_click_handle() -> void:
	if app_name == null:
		return

	if $Button.double_clicked():
		AppNames.app_list[app_name].run_app()
