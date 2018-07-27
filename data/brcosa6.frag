#version 410
#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER


varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform sampler2D texture2;
float thresh = 0.2f;

void main() {
	vec4 texColor = texture2D(texture, vertTexCoord.xy).rgba * 1.25;
	vec2 repos = vec2(vertTexCoord.x + 0.01, vertTexCoord.y - 0.05);
	vec4 texColor2 = texture2D(texture, repos).rgba * 0.75;
	gl_FragColor = vec4(mix(texColor2, texColor, 0.5));
}
