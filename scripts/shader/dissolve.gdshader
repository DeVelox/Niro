shader_type canvas_item;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 438.5453);
}

uniform sampler2D tile;
uniform float alpha : hint_range(0.0, 1.0);

void fragment() {
	// Get size of texture in pixels
	float size_x = float(textureSize(tile, 0).x);
	float size_y = float(textureSize(tile, 0).y);
	// 
	vec4 pixelColor = texture(tile, UV);
	// Create a new "UV" which remaps every UV value to a snapped pixel value
	vec2 UVr = vec2(floor(UV.x*size_x/2.0)/size_x, floor(UV.y*size_y/2.0)/size_y);
	// Determine whether pixel should be visible or not
	float visible = step(alpha, random(UVr));
	// Draw the pixel, or not depending on if it is visible or not
	COLOR = vec4(pixelColor.r, pixelColor.g, pixelColor.b, min(visible, pixelColor.a));
}