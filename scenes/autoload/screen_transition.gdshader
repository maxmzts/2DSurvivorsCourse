shader_type canvas_item;

uniform vec4 transition_color : source_color;
uniform sampler2D transition_texture : filter_nearest; // add filter_nearest to preserve pixel for pixel art
uniform float percent: hint_range(0.0, 1.0);

void fragment() {
	// Called for every pixel the material is visible on.
	// grabs a color of the texture at the same UV than the pixel being calculated
	vec4 transition_texture_color = texture(transition_texture, UV);
	if (transition_texture_color.r > percent){
		COLOR.a  = 0.0;
	} else {
		COLOR = transition_color;
	}
}

