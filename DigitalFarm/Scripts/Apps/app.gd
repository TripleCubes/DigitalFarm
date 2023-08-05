class_name App
extends Node2D

var _window_wrapper_scene: PackedScene

func run_app() -> void:
	var window_wrapper: = _window_wrapper_scene.instantiate()
	add_child(window_wrapper)
