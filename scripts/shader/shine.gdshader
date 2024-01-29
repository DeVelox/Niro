shader_type canvas_item;

uniform float speed = 1.0;
uniform vec4 tint : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float span : hint_range(0.1, 1.0) = 0.3;

float luminance(vec4 colour) {
	return 1.0 - sqrt(0.299*colour.r*colour.r + 0.587*colour.g*colour.g + 0.114*colour.b*colour.b);
}

void fragment() {
	vec4 colour = texture(TEXTURE, UV);
	float target = abs(sin(alpha * TIME * PI * speed / 2.0) * (1.0 + span));
	if(colour.a > 0.0) {
		float lum = luminance(colour);
		float diff = abs(lum - target);
		float mx = clamp(1.0 - diff / span, 0.0, 1.0);
		colour = mix(colour, tint, mx);
	}
	
	COLOR = colour;
	COLOR.a *= alpha;
}