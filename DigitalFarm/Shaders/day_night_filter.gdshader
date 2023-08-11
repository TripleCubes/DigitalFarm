shader_type canvas_item;

uniform vec4 day_color_list[20];
uniform vec4 night_color_list[20];
uniform int color_count = 0;

bool color_equals(vec4 color0, vec4 color1) {
	return abs(color0.r - color1.r) < 0.01
				&& abs(color0.g - color1.g) < 0.01
				&& abs(color0.b - color1.b) < 0.01
				&& abs(color0.a - color1.a) < 0.01;
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = texture_color;

	for (int i = 0; i < color_count; i++) {
		if (!color_equals(texture_color, day_color_list[i])) {
			continue;
		}

		COLOR = night_color_list[i];
		break;
	}
}
