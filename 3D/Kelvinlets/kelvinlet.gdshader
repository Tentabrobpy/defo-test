// https://graphics.pixar.com/library/Kelvinlets/paper.pdf
shader_type spatial;
render_mode world_vertex_coords, unshaded;
#include "res://inc/linalg_helpers.gdshaderinc"

uniform vec3 force;
uniform vec3 origin;
uniform float brush_size = 0.5;
uniform float volume_preservation : hint_range(0.0, 0.5) = 0.5;
uniform sampler2D gradient : repeat_disable;

// Eq. 6
vec3 kelvinlet(float a, float b, float epsilon, vec3 r, vec3 f) {
	float r_epsilon = sqrt(dot(r, r) + epsilon * epsilon);
	float r_epsilon_3 = r_epsilon * r_epsilon * r_epsilon;
	float term_1 = (a - b) / r_epsilon;
	float term_2 = b / r_epsilon_3;
	float term_3 = a * 0.5 * epsilon * epsilon / r_epsilon_3;
	mat3 K_epsilon = (term_1 + term_3) * I + term_2 * mul_aa_t(r);
	return K_epsilon * f;
}

// Eq. 7
vec3 displacement(float a, float b, float epsilon, vec3 r, vec3 u) {
	float c = 2.0 / (3.0 * a - 2.0 * b);
	return c * epsilon * kelvinlet(a, b, epsilon, r, u);
}

void vertex() {
	float mu = 1.0;
	float v = volume_preservation;
	float a = 1.0 / (4.0 * PI * mu);
	float b = a / (4.0 * (1.0 - v));
	vec3 u = displacement(a, b, brush_size, VERTEX - origin, force);
	COLOR.rgb = texture(gradient, vec2(length(u) * 0.125, 0.0)).rgb;
	VERTEX += u;
}

void fragment() {
	ALBEDO = COLOR.rgb;
}