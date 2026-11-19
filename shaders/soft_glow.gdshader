shader_type canvas_item;
// Blur Gaussian satu pass dari alpha tekstur, diwarnai glow_color.
// Dipakai untuk glow judul (tekstur dari SubViewport).

uniform vec4 glow_color : source_color = vec4(1.0, 0.86, 0.62, 1.0);
uniform float strength : hint_range(0.0, 4.0) = 1.0;
// Radius blur dalam piksel tekstur.
uniform float radius : hint_range(0.0, 64.0) = 10.0;

void fragment() {
	const int TAPS = 6; // sampel per sisi -> (2*6+1)^2 sampel
	vec2 step_uv = TEXTURE_PIXEL_SIZE * radius / float(TAPS);
	float sigma = float(TAPS) * 0.5;
	float sum = 0.0;
	float wsum = 0.0;
	for (int x = -TAPS; x <= TAPS; x++) {
		for (int y = -TAPS; y <= TAPS; y++) {
			float w = exp(-float(x * x + y * y) / (2.0 * sigma * sigma));
			sum += texture(TEXTURE, UV + vec2(float(x), float(y)) * step_uv).a * w;
			wsum += w;
		}
	}
	float a = clamp(sum / wsum * strength, 0.0, 1.0);
	COLOR = vec4(glow_color.rgb, glow_color.a * a);
}
