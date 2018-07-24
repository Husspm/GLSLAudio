#version 410
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER


varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform sampler2D texture2;
uniform float depth;
float thresh = 0.2f;

void main() {
	vec4 texColor = texture2D(texture, vertTexCoord.xy).rgba * 2.0;
	vec2 repos = vec2(vertTexCoord.x + 0.001, vertTexCoord.y - 0.001);
	vec4 texColor2 = texture2D(texture, repos).rgba * 3.0;
//	if (texColor.r < thresh || texColor.b < thresh || texColor.b < thresh){
//	gl_FragColor = vec4(0, 0, 0, 1);
//	}else{
//  	gl_FragColor = vec4(texColor, 0.75);
//	}
	gl_FragDepth = depth;
	gl_FragColor = vec4(mix(texColor, texColor2, 0.24));
}


