extends Node

const DAY_NIGHT_TRANSITION_TIME_SEC: float = 0.4

var at_night: = false

var at_night_float: float = 0

func _process(_delta):
	if at_night:
		at_night_float += _delta
	else:
		at_night_float -= _delta

	if at_night_float > 1:
		at_night_float = 1
	elif at_night_float < 0:
		at_night_float = 0

	if Input.is_action_just_pressed("KEY_3"):
		at_night = not at_night
