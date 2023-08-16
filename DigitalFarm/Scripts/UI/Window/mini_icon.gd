class_name UI_Window_MiniIcon
extends Node2D

@onready var window: Node2D = get_parent().get_node("Window")

var show_mini_icon: = false:
	set(val):
		if show_mini_icon == val:
			return

		show_mini_icon = val
		
		if show_mini_icon:
			_show_mini_icon()
		else:
			_hide_mini_icon()

func _ready():
	self.hide()

func _process(_delta):
	if not show_mini_icon:
		return

	var mouse_pos: = GlobalFunctions.get_mouse_pos()
	self.position.x = mouse_pos.x
	self.position.y = mouse_pos.y

func _show_mini_icon() -> void:
	self.show()
	window.modulate.a = 0

func _hide_mini_icon() -> void:
	self.hide()
	window.modulate.a = 1
