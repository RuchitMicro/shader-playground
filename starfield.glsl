mat2 rotate(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

float Star(in vec2 uv){
    float d = length(uv);
    float m = 0.01/d;
    
    m *= smoothstep(0.8, 0.2, d);
    return m;
}

float Hash21(vec2 p){
    p = fract(p * vec2(5977.34, 47556.21));
    p += dot(p, p+536.245);
    return fract(p.x*p.y);
}

float StarLayer(vec2 uv){
    float d;
    vec2 id = floor(uv);
    
    //uv += rotate(uv*fract(id*29.4), .3);
    
    vec2 gv = fract(uv)-0.5;
    
    for(int y=-1; y<=1; y++){
        for(int x=-1; x<=1; x++){
            vec2 offset = vec2(x,y);
            
            float n = Hash21(id+offset)-0.5;
    
            float star = Star(gv - offset - vec2(n, n * fract(n*294.12) ));
            float scale = fract(n * 2341.259);
            star *= scale;
            d += star;
        }
    }
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    uv *= 0.3;
    
    
    // vec2 M = (iMouse.xy - iResolution.xy * .5) / iResolution.y;
    //uv += M;
    
    vec2 uv_0 = uv;
    vec3 final_color = vec3(0.0);
    
    uv *= rotate(iTime*0.1);
    
    
    float d;
    for(float i=0.; i<=1.; i+=1./10.){
        float depth = fract(i+iTime*0.1);
        float scale = mix(20., .5, depth);
        float fade = depth * smoothstep(1., .8, depth);
        d += StarLayer(uv*rotate(i*20.)*scale-i*0.24)*fade;
    }
    
    
    // GRID
    //if(gv.x>0.48 || gv.y>0.48) final_color.r = 1.;
    
    
    final_color += d;
    
    fragColor = vec4(final_color, 1.0);
}



