extends Node

func box_collision_check(x1: float, w1: float, x2: float, w2: float) -> bool:
	if (x1 >= x2 and x1 <= x2 + w2) or (x1 + w1 >= x2 and x1 + w1 <= x2 + w2) \
	or (x2 >= x1 and x2 <= x1 + w1) or (x2 + w2 >= x1 and x2 + w2 <= x1 + w1):
		return true
	return false
	
func windows_overllap(window1: Node2D, window2: Node2D) -> bool:
	var x1: float = window1.position.x
	var y1: float = window1.position.y
	var w1: float = window1.w
	var h1: float = window1.h
	var x2: float = window2.position.x
	var y2: float = window2.position.y
	var w2: float = window2.w
	var h2: float = window2.h
	
	return box_collision_check(x1, w1, x2, w2) \
	and box_collision_check(y1, h1, y2, h2)
