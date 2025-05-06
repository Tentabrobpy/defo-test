// https://inria.hal.science/hal-00753246/file/TOG2012_Gourmel_et_al_preprint.pdf
// Very simple proof-of-concept using ideas from Gourmel et al.
shader_type canvas_item;
#include "res://inc/sdf_2D.gdshaderinc"

uniform vec2 ball1_offset;
uniform vec2 ball2_offset;

/**
 * Local shape of the blend operator
 */
uniform sampler2D blend_profile : repeat_disable;
/**
 * Defines the blend strength over angles from 0 to π
 */
uniform sampler2D opening : repeat_disable;
uniform float blend_thickness = 1.0;

void vertex() {
	UV -= 0.5;
	UV *= 10.0;
}

void fragment() {
	vec2 ball1_uv_offset = vec2(-ball1_offset.x, ball1_offset.y);
	vec3 ball1_sdf = sdg_circle(UV + ball1_uv_offset, 2.0);
	float ball1 = ball1_sdf.r;
	vec2 ball1_grad = ball1_sdf.gb;

	vec2 ball2_uv_offset = vec2(-ball2_offset.x, ball2_offset.y);
	vec3 ball2_sdf = sdg_circle(UV + ball2_uv_offset, 1.0);
	float ball2 = ball2_sdf.r;
	vec2 ball2_grad = ball2_sdf.gb;

	float union = add(ball1, ball2);
	float t = abs(ball1 - ball2) / blend_thickness;
	float blend = union - texture(blend_profile, vec2(t, 0.0)).r;
	t = acos(dot(ball1_grad, ball2_grad)) / PI;
	blend = mix(blend, union, texture(opening, vec2(t, 0.0)).r);
	blend = evaluate(blend);

	vec3 color = vec3(1.0, blend, blend);
	COLOR.rgb = color;
}