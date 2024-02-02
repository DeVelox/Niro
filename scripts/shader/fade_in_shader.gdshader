shader_type canvas_item;

uniform sampler2D atlas;
uniform int frame : hint_range(0, 10) = 0;
uniform int atlas_x = 0;
uniform int atlas_y = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float tiles_x = 27.0;
	float tiles_y = 20.0;
	float frames_x = 1.0;
	float frames_y = 10.0;
	float grid_x = frames_x * tiles_x;
	float grid_y = frames_y * tiles_y;
	float tile_h = UV.x / grid_x;
	float tile_v = UV.y / grid_y;
	float coord_x = float(atlas_x) / grid_x;
	float coord_y = float(atlas_y) / grid_y;
	float current_frame = float(frame) / frames_y;
	
	
	COLOR = texture(atlas, vec2(tile_h + coord_x, tile_v + coord_y + current_frame));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
