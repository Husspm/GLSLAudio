Particle [] p;
import processing.sound.*;
AudioIn mic;
Amplitude vol;
PGraphics partCanvas;
void setup() {
  size(800, 600, P2D);
  smooth(8);
  background(0);
  partCanvas = createGraphics(width, height, P2D);
  p = new Particle[600];
  for (int i = 0; i < p.length; i ++) {
    p[i] = new Particle();
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
  frame.setTitle(str(floor(frameRate)));
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
  image(partCanvas, 0, 0);
  //saveFrame();
}


class Particle {
  PVector pos, acc, spawn;
  float noiseVal = 0;
  float angleOffset;
  float noiseScale = 0.004;
  float sizeMax;
  Particle() {
    pos = new PVector(width / 2, height / 2);
    spawn = pos;
    acc = new PVector(random(0.8, 1.3), random(0.9, 1.3));
    angleOffset = acc.x * 0.3;
    sizeMax = acc.x * 104;
  }
  void move(float vol) {
    noiseVal += angleOffset;
    float angle = noise(pos.x * noiseScale, pos.y * noiseScale, angleOffset);
    acc.rotate(map(angle, 0, 1, -PI / 64, PI / 64));
    pos.add(acc.copy().mult(vol * 24));
    this.display(angle, vol);
  }
  void display(float angle, float vol) {
    partCanvas.noStroke();
    partCanvas.fill(angle * 300, 0, random(255),  vol * 150);
    //dist(spawn.x, spawn.y, pos.x, pos.y) * 0.095);
    float newPosX = map(pos.x, 0, width, width, 0);
    float newPosY = map(pos.y, 0, height, height, 0);
    partCanvas.ellipse(pos.x, pos.y, angle * sizeMax, angle * sizeMax);
    partCanvas.ellipse(newPosX, pos.y, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
    partCanvas.ellipse(newPosX, newPosY, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
    partCanvas.ellipse(pos.x, newPosY, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
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
