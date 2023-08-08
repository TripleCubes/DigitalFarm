@tool
class_name UI_Text
extends RichTextLabel

const CHAR_SHOW_SPEED: float = 50 # Character per sec

var char_shown: float = 0;

func _ready():
	scroll_active = false
	theme = preload("res://Themes/theme.tres")
	visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	visible_characters = -1
	char_shown = get_total_character_count()

func _process(_delta):
	if Engine.is_editor_hint():
		return

	char_shown += CHAR_SHOW_SPEED*_delta
	var char_count: = get_total_character_count()
	if char_shown > char_count:
		char_shown = char_count

	visible_characters = int(char_shown)

func show_text(in_text: String) -> void:
	text = in_text
	char_shown = 0
