// cosine based palette, 4 vec3 params
vec3 color_palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

float sdEquilateralTriangle( in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec3 single_layer( out vec4 fragColor, in vec2 fragCoord )
{
    /*
    fragCoord * 2.0: Scales the fragment coordinates to range between [0, 2 * fragCoord].
    - iResolution.xy: Centers the coordinates around the middle of the screen, adjusting the range to [-iResolution.xy, iResolution.xy].
    / iResolution.y: Normalizes the coordinates with respect to the screen's height, ensuring both x and y are scaled correctly and the aspect ratio is preserved.
    */
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    
    // Preserve original UV for future use
    vec2 uv_0 = uv;
    
    // Global for Final Color Value
    vec3 final_color = vec3(0.0);
    
    
    
    for(float i = 0.0; i < 4.0; i++){
    
        // The below code will allow space repetition
        // We can sort of split the full shader effect into multiple fragments
        //uv *= 2.0;
        //uv = fract(uv);
        //uv -= 0.5;
        
        uv = fract(uv * 1.5) - 0.5;
        
    
        //if (i < 4.0){
            // This code adds rotation to the animation
            //float angle = -iTime / 2.; // Adjust the angle as needed, here it is animated with time
            //mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
            //uv *= rotation;
        //}
        // This code creates a Box
        //vec2 b = vec2(1., 1.);
        //float d = sdBox(uv, b);

        // This code creates a triangle
        float d = sdEquilateralTriangle(uv, 0.0);
        
        
        // Multiplying by this exponentional function
        d *= exp(-sdEquilateralTriangle(uv_0, 0.5));


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
        //d = step(0.1, d);


        // Smooth Step function will take a 2 thresholds
        // any value below that threshold will be assigned a 0 
        // and any value above that threshold will assign a 1
        // the values between these 2 threshold will be interpolated
        // d = smoothstep(0.0, 0.5, d);


        // Inverse function has a graph that will invert the values of d
        // This function is used here to control color intensity
        d = 0.01 / d;


        // Coloring the glow
        // We are using a cosine color pallet with 4 parameters to control gradient
        // Check out https://iquilezles.org/articles/palettes/ to know more   
        vec3 color_param_1 = vec3(0.5, 0.5, 0.5);
        vec3 color_param_2 = vec3(0.5, 0.5, 0.5);
        vec3 color_param_3 = vec3(1.0, 1.0, 1.0);
        vec3 color_param_4 = vec3(0.263, 0.416, 0.557);
        vec3 color = color_palette(length(uv_0) + iTime*0.3 + i*0.4, color_param_1, color_param_2, color_param_3, color_param_4);

        final_color += color * d;

        // fragColor = vec4(final_color, 1.0);
    }
    
    return final_color;
    
}


void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    // Global for Final Color Value
    vec3 final_color = single_layer(fragColor, fragCoord);
    
    
    fragColor = vec4(final_color, 1.0);
}





