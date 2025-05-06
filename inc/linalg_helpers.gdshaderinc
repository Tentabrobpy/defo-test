const mat3 I = mat3(
	vec3(1, 0, 0),
	vec3(0, 1, 0),
	vec3(0, 0, 1)
);

// Multiply a by its own transpose
mat3 mul_aa_t(vec3 a) {
	float xx = a.x * a.x;
	float xy = a.x * a.y;
	float xz = a.x * a.z;
	float yy = a.y * a.y;
	float yz = a.y * a.z;
	float zz = a.z * a.z;
	return mat3(
		vec3(xx, xy, xz),
		vec3(xy, yy, yz),
		vec3(xz, yz, zz)
	);
}

// Multiply a by transpose of b
mat3 mul_ab_t(vec3 a, vec3 b) {
	float xx = a.x * b.x;
	float xy = a.x * b.y;
	float xz = a.x * b.z;
	float yx = a.y * b.x;
	float yy = a.y * b.y;
	float yz = a.y * b.z;
	float zx = a.z * b.x;
	float zy = a.z * b.y;
	float zz = a.z * b.z;
	return mat3(
		vec3(xx, xy, xz),
		vec3(yx, yy, yz),
		vec3(zx, zy, zz)
	);
}