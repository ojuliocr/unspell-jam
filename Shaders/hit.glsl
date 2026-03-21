vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 c = Texel(tex, texture_coords);
    if (c.a == 0.0) return c;
    return vec4(1.0, 1.0, 1.0, c.a);
}