extends Node2D

var window_wrapper: WindowWrapper

func _draw():
	var grid_wh: Vector2i = window_wrapper._get_grid_wh()

	for x in grid_wh.x:
		for y in grid_wh.y:
			var light: = false
			var y_odd: = false
			var x_odd: = false

			if y % 2 == 1:
				y_odd = true
			if x % 2 == 1:
				x_odd = true
			
			if x_odd == y_odd:
				light = true

			if not light:
				continue

			var tile_xy_pixel: Vector2 = window_wrapper._get_tile_xy_pixel_from_tile_xy(Vector2i(x, y))
			draw_rect(Rect2(tile_xy_pixel.x, tile_xy_pixel.y, window_wrapper.TILE_W, window_wrapper.TILE_H), 
								Colors.COLOR_BACKGROUND_LIGHT_DAY, true)
