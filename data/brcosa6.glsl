#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER


varying vec4 vertTexCoord;
uniform sampler2D texture;
float thresh = 0.2f;

void main() {
	vec3 texColor = texture2D(texture, vertTexCoord.xy).rgb;
	vec2 repos = vec2(vertTexCoord.x - 0.01, vertTexCoord.y - 0.01);
	vec3 texColor2 = texture2D(texture, repos).rgb * 3.0;
//	if (texColor.r < thresh || texColor.b < thresh || texColor.b < thresh){
//	gl_FragColor = vec4(0, 0, 0, 1);
//	}else{
//  	gl_FragColor = vec4(texColor, 0.75);
//	}
	gl_FragColor = vec4(mix(texColor, texColor2, 0.15), 0.79);
}


