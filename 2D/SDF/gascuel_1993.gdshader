// https://dl.acm.org/doi/pdf/10.1145/166117.166157
shader_type canvas_item;
#include "res://inc/sdf_2D.gdshaderinc"

uniform vec2 ball1_offset;
uniform vec2 ball2_offset;

float a(float r, float k, float a_0, float w) {
	if (r < 0.0 || r > w) {
		return 0.0;
	}
	float r_2 = r * r;
	float r_3 = r_2 * r;
	float w_2 = w * w;
	float w_3 = w_2 * w;
	if (r < w * 0.5) {
		float c = 4.0 * (w * k - 4.0 * a_0) / w_3;
		float d = 4.0 * (3.0 * a_0 - w * k) / w_2;
		return c * r_3 + d * r_2 + k * r;
	}
	else {
		return 4.0 * a_0 * (r - w) * (r - w) * (4.0 * r - w) / w_3;
	}
}

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
	
	float ball1_contact = ball2 < 0.0 ? ball2 : 0.0;
	float ball1_deform = a(ball2, 1.0, 0.25, 1.0);
	
	float ball2_contact = ball1 < 0.0 ? -ball1 : 0.0;
	float ball2_deform = a(ball1, 1.0, 0.125, 1.0);
	
	ball1 = evaluate(ball1 + ball1_contact - ball1_deform);
	ball2 = evaluate(ball2 + ball2_contact - ball2_deform);

	vec3 ball1_color = vec3(1.0, ball1, ball1);
	vec3 ball2_color = vec3(ball2, ball2, 1.0);
	vec3 color = mix(ball2_color, ball1_color, ball2);
	COLOR.rgb = color;
}