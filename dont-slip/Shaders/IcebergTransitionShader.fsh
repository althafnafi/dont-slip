////
////  IcebergTransitionShader.fsh
////  dont-slip
////
////  Created by mac.bernanda on 20/06/24.
////

void main() {
    // find the current pixel color
    vec4 current_color = texture2D(u_texture, v_tex_coord);

    // if it's not transparent
    if (current_color.a > 0.0) {
        // subtract its current RGB values from 1 and use its current alpha; multiply by the node alpha so we can fade in or out
        gl_FragColor = vec4(1.0 - current_color.rgb, current_color.a) * current_color.a * v_color_mix.a;
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}
