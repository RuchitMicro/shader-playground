// cosine based palette, 4 vec3 params
vec3 color_palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    /*
    fragCoord * 2.0: Scales the fragment coordinates to range between [0, 2 * fragCoord].
    - iResolution.xy: Centers the coordinates around the middle of the screen, adjusting the range to [-iResolution.xy, iResolution.xy].
    / iResolution.y: Normalizes the coordinates with respect to the screen's height, ensuring both x and y are scaled correctly and the aspect ratio is preserved.
    */
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    
    // Preserve original UV for future use
    vec2 uv_0 = uv;
    
    // The below code will allow space repetition
    // We can sort of split the full shader effect into multiple fragments
    uv *= 2.0;
    uv = fract(uv);
    uv -= 0.5;
    
    
    vec2 b = vec2(0.0, 0.0);
    float d = sdBox(uv, b);
    
    // Sin Function will allow the d value to be changed such that 
    // for every value of d the new value of d will be caluculated through a cyclic range (sin function's primary feature) 
    // this cyclic range can be manipulated through constants like multiplying d with a float
    // and/or by introducing time components or scroll offsets
    d = sin(d * 8.0 - iTime)/8.0;
    
    // Absolute function will remove the negative sign
    // So -1 will become 1 and -0.5 will become 0.5
    d = abs(d);
    
    // Step function will take a threshold
    // any value below that threshold will be assigned a 0 
    // and any value above that threshold will assign a 1
    // d = step(0.1, d);
    
    
    // Smooth Step function will take a 2 thresholds
    // any value below that threshold will be assigned a 0 
    // and any value above that threshold will assign a 1
    // the values between these 2 threshold will be interpolated
    // d = smoothstep(0.0, 0.5, d);
    
    
    // Inverse function has a graph that will invert the values of d
    // This function is used here because of output coolness
    d = 0.02 / d;
    
    
    // Coloring the glow
    // We are using a cosine color pallet with 4 parameters to control gradient
    // Check out https://iquilezles.org/articles/palettes/ to know more
    vec3 color_param_1 = vec3(0.5, 0.5, 0.5);
    vec3 color_param_2 = vec3(0.5, 0.5, 0.5);
    vec3 color_param_3 = vec3(1.0, 1.0, 1.0);
    vec3 color_param_4 = vec3(0.263, 0.416, 0.557);
    vec3 color = color_palette(length(uv_0)+iTime, color_param_1, color_param_2, color_param_3, color_param_4);
    color *= d;
    
    fragColor = vec4(color, 1.0);
    
}
