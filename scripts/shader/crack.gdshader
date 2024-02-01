shader_type canvas_item;

uniform sampler2D tile;
uniform float alpha;


void fragment() {
	vec4 background = texture(tile, UV);
	vec4 crack = texture(TEXTURE, UV) * alpha;
	
	COLOR = background * crack;
}
