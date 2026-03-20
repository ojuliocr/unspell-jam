extern Image dissolve_texture;
extern float dissolve_value;
extern float burn_size;
extern vec4 burn_color;

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
    vec4 main_texture = Texel(texture, texCoords);
    vec4 noise_texture = Texel(dissolve_texture, texCoords);

    float burn_size_step = burn_size * step(0.001, dissolve_value) * step(dissolve_value, 0.999);
    float threshold = smoothstep(noise_texture.x - burn_size_step, noise_texture.x, dissolve_value);
    float border = smoothstep(noise_texture.x, noise_texture.x + burn_size_step, dissolve_value);

    vec4 result = main_texture;
    result.a *= threshold;
    result.rgb = mix(burn_color.rgb, main_texture.rgb, border);

    return result * color;
}