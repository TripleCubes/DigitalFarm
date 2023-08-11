extends Node

const COLOR_BACKGROUND_DAY: = Color("CC8747")
const COLOR_LINE_DAY: = Color("FFE59E")

enum ColorIndex {
	WHITE,

	BACKGROUND,
	LINE,

	BLUE,
	GREEN,
	YELLOW,
}

var color_list: = {}

func _ready():
	color_list[ColorIndex.WHITE] = {
		day = Color(1, 1, 1),
		night = Color(1, 1, 1),
	}

	color_list[ColorIndex.BACKGROUND] = {
		day = Color("CC8747"),
		night = Color("6079A0"),
	}
	color_list[ColorIndex.LINE] = {
		day = Color("FFE59E"),
		night = Color("E5EDFF"),
	}

	color_list[ColorIndex.BLUE] = {
		day = Color("9AEDF9"),
		night = Color("9AEDF9"),
	}
	color_list[ColorIndex.GREEN] = {
		day = Color("6AE25A"),
		night = Color("59FF7F"),
	}
	color_list[ColorIndex.YELLOW] = {
		day = Color("FFD954"),
		night = Color("FFECA8"),
	}
