#version 410
#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER
#define SHADER_VERT  0
#define SHADER_FRAG  0

varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform sampler2D texture2;
float thresh = 0.2f;


#if (SHADER_FRAG == 0)
void main() {
	vec4 texColor = texture2D(texture, vertTexCoord.xy).rgba;
	vec2 repos = vec2(vertTexCoord.x + 0.01, vertTexCoord.y + 0.01);
	vec4 texColor2 = texture2D(texture2, repos).rgba;
	gl_FragColor = vec4(mix(texColor2, texColor, 0.5));
}

#endif
