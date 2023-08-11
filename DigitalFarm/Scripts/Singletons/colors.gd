extends Node

const COLOR_BACKGROUND_DAY: = Color("CC8747")
const COLOR_LINE_DAY: = Color("FFE59E")

enum ColorIndex {
	WHITE,

	BACKGROUND,
	LINE,

	BLUE,
	GREEN,
	DARK_GREEN,
	YELLOW,
}

var color_list: = {}

func _ready():
	color_list[ColorIndex.WHITE] = {
		day = Color(1, 1, 1),
		night = Color(1, 1, 1),
	}

	color_list[ColorIndex.BACKGROUND] = {
		day = COLOR_BACKGROUND_DAY,
		night = Color("605989"),
	}
	color_list[ColorIndex.LINE] = {
		day = COLOR_LINE_DAY,
		night = Color("D0CBED"),
	}

	color_list[ColorIndex.BLUE] = {
		day = Color("9AEDF9"),
		night = Color("8BD6E0"),
	}
	color_list[ColorIndex.GREEN] = {
		day = Color("6AE25A"),
		night = Color("93D896"),
	}
	color_list[ColorIndex.DARK_GREEN] = {
		day = Color("E0D46D"),
		night = Color("B5AA58"),
	}
	color_list[ColorIndex.YELLOW] = {
		day = Color("FFD954"),
		night = Color("F7ECB2"),
	}
