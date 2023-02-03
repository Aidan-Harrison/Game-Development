shader_type canvas_item;

uniform sampler2D tex;

void fragment() {
	vec4 col = texture(tex, UV);
	vec2 uv_coords;
	
	if(col == vec4(0.0,0.0,0.0,1.0)) {
		COLOR = vec4(cos(TIME) + 0.5, sin(TIME) + 0.5,cos(TIME + 0.5),1.0);
	} else {
		COLOR = vec4(0.0,0.0,0.0,0.0);
	}
}
