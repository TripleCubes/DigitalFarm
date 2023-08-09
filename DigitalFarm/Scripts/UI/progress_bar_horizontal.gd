@tool
class_name UI_ProgressBarHorizontal
extends Node2D

@export var length: float
@export var color: Color
@export var fill_time_sec: float
@export var reverse_fill_time_sec: float
@export var init_filled: bool
@export var init_reversed: bool
@export var reverse_when_full: bool
@export var init_paused: bool

var progress: float = 0
var reversed: = false
var paused: = false

func _ready():
	if length == 0:
		length = 100
	if color == Color(0, 0, 0):
		color = Color(1, 1, 1)
	if fill_time_sec == 0: 
		fill_time_sec = 5
	if reverse_fill_time_sec == 0: 
		reverse_fill_time_sec = 5

	reversed = init_reversed
	paused = init_paused
	if init_filled:
		progress = 1

func _draw():
	draw_rect(Rect2(2,          0,  length - 4, 2), Consts.COLOR_LINE)
	draw_rect(Rect2(2,          10, length - 4, 2), Consts.COLOR_LINE)
	draw_rect(Rect2(0,          2,  2,          8), Consts.COLOR_LINE)
	draw_rect(Rect2(length - 2, 2,  2,          8), Consts.COLOR_LINE)
	draw_rect(Rect2(4, 4, (length - 8) * progress, 4), color)

func _process(_delta):
	_progress_process(_delta)

	queue_redraw()

func _progress_process(_delta: float) -> void:
	if paused:
		return

	if not reversed:
		progress += _delta / fill_time_sec
		if progress <= 1:
			return

		progress = 1
		if reverse_when_full:
			reversed = true
		return

	progress -= _delta / reverse_fill_time_sec
	if progress >= 0:
		return
		
	progress = 0
	if reverse_when_full:
		reversed = false
