extends Node2D

const _window_wrapper_scene: = preload("res://Scenes/Apps/window_pot.tscn")

func run_app() -> void:
	var window_wrapper: = _window_wrapper_scene.instantiate()
	add_child(window_wrapper)
