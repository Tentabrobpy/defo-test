// https://iquilezles.org/articles/distgradfunctions2d/
vec3 sdg_circle( vec2 p, float r ) {
    float d = length(p);
    return vec3( d-r, p/d );
}

vec3 sdg_box( in vec2 p, in vec2 b ) {
    vec2 w = abs(p)-b;
    vec2 s = vec2(p.x<0.0?-1.0:1.0,p.y<0.0?-1.0:1.0);
    float g = max(w.x,w.y);
    vec2  q = max(w,0.0);
    float l = length(q);
    return vec3(   (g>0.0)?l  :g,
                s*((g>0.0)?q/l:((w.x>w.y)?vec2(1,0):vec2(0,1))));
}

float evaluate(float sdf) {
	return step(0.0, sdf);
}

float evaluate_at(float sdf, float d) {
	return step(d, sdf);
}

float isoline(float sdf) {
	return step(fract(sdf * 4.0), 0.75);
}

float add(float a, float b) {
	return min(a, b);
}

float sub(float a, float b) {
	return max(a, -b);
}

float intersect(float a, float b) {
	return max(a, b);
}