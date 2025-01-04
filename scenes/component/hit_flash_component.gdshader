shader_type canvas_item; //type of the shader

uniform float lerp_percent: hint_range(0.0, 1.0);

// Called for every vertex the material is visible on.
void vertex() {

}
// Called for every pixel the material is visible on.
void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = mix(texture_color, vec4(.8,0,0,texture_color.a), lerp_percent);
	COLOR = final_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
