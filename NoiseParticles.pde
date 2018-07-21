Particle [] p;
import processing.sound.*;
AudioIn mic;
Amplitude vol;
PGraphics partCanvas;
PShader shade;

void setup() {
  size(800, 600, P3D);
  smooth(8);
  background(0);
  partCanvas = createGraphics(width, height, P3D);
  shade = loadShader("brcosa6.glsl");
  p = new Particle[600];
  for (int i = 0; i < p.length; i ++) {
    p[i] = new Particle(i);
  }
  mic = new AudioIn(this, 0);
  vol = new Amplitude(this);
  mic.start();
  vol.input(mic);
}
float smooth = 0.41;
float v = 0;
int counter = 0;
void draw() {
  surface.setTitle(str(floor(frameRate)));
  counter++;
  //background(0);
  partCanvas.beginDraw();
  partCanvas.background(0);
  v += (vol.analyze() - v) * smooth;
  if ( v*10 > 4 && counter > 60) {
    newPos();
    counter = 0;
  }
  for (Particle p : p) {
    p.move(v);
    //p.display();
    //p.checkPos();
  }
  partCanvas.endDraw();
  shader(shade);
  image(partCanvas, 0, 0);
  //saveFrame();
}


class Particle {
  PVector pos, acc, spawn, upwards;
  int prevIndex;
  float noiseVal = 0;
  float angleOffset;
  float noiseScale = 0.0004;
  float sizeMax;
  Particle(int index) {
    prevIndex = index - 1;
    pos = new PVector(width / 2, height / 2);
    spawn = pos;
    acc = new PVector(random(1.8, 2.3), random(1.9, 2.3));
    upwards = new PVector(0, -0.5);
    angleOffset = acc.x * 0.03;
    sizeMax = acc.x * 52;
  }
  void move(float vol) {
    noiseVal += angleOffset;
    float angle = noise(pos.x * noiseScale, pos.y * noiseScale, noiseVal);
    if (prevIndex != -1) {
      pos.add(upwards.copy().rotate(
        dist(pos.x, pos.y, p[prevIndex].pos.x, p[prevIndex].pos.y) / 20));
    }
    acc.rotate(map(angle, 0, 1, -PI / 64, PI / 64));
    pos.add(acc.copy().mult(0.46));
    pos.add(upwards);
    this.display(angle, vol);
  }
  void display(float angle, float vol) {
    partCanvas.noStroke();
    partCanvas.fill(angle * 300, 200, noise(angle) * 250, 20);
    //dist(spawn.x, spawn.y, pos.x, pos.y) * 0.095);
    float newPosX = map(pos.x, 0, width, width, 0);
    float newPosY = map(pos.y, 0, height, height, 0);
    partCanvas.ellipse(pos.x, pos.y, angle * sizeMax, angle * sizeMax);
    //partCanvas.ellipse(newPosX, pos.y, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
    //partCanvas.ellipse(newPosX, newPosY, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
    //partCanvas.ellipse(pos.x, newPosY, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
  }
  void checkPos() {
    if (pos.x > width || pos.x < 0) {
      pos.x = width / 2;
    }
    if (pos.y > height || pos.y < 0) {
      pos.y = height / 2;
    }
  }
}
void mousePressed() {
  background(0);
  partCanvas.beginDraw();
  partCanvas.background(0);
  partCanvas.endDraw();
  for (Particle p : p) {
    p.pos.x = mouseX;
    p.pos.y = mouseY;
    p.spawn = new PVector(mouseX, mouseY);
  }
}
void newPos() {
  float rndX = random(width);
  float rndY = random(height);
  for (Particle p : p) {
    p.pos.x = rndX;
    p.pos.y = rndY;
    p.spawn = new PVector(rndX, rndY);
  }
}
