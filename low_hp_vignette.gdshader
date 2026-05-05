shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 vignette_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV;
    vec2 center = uv - 0.5;
    float dist = dot(center, center) * 2.5;
    float vignette = smoothstep(0.3, 1.0, dist);
    COLOR = vec4(vignette_color.rgb, vignette * intensity * 0.85);
}