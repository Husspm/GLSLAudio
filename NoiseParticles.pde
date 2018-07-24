Particle [] p;
PGraphics partCanvas;
PShader shade;
PImage sprite, tex;
int state = 0;
int DIR () {
  int [] d = {-1, 1};
  return d[floor(random(d.length))];
}

void setup() {
  size(800, 600, P3D);
  smooth(8);
  background(0);
  frameRate(1000);
  partCanvas = createGraphics(width, height, P3D);
  shade = loadShader("brcosa6.glsl");
  sprite = loadImage("sprite.png");
  tex = loadImage("Capture1.png");
  p = new Particle[510];
  for (int i = 0; i < p.length; i ++) {
    p[i] = new Particle(i);
  }
}
float smooth = 0.11;
int counter = 0;
float dep = 10;
void draw() {
  if (state == 0) {
    return;
  } else {
    surface.setTitle(str(round(frameRate)));
    counter++;
    dep *= 0.99;
    //background(0);
    shade.set("depth", dep);
    partCanvas.beginDraw();
    partCanvas.background(0, 20);
    //partCanvas.rect(0, 0, width, height);
    partCanvas.shader(shade);
    for (Particle p : p) {
      p.move();
      //p.display();
      //p.checkPos();
    }
    partCanvas.endDraw();
    //shader(shade);
    //tint(255, 10);
    image(partCanvas, 0, 0);
    //saveFrame();
  }
}


class Particle {
  PVector pos, acc, spawn, upwards;
  int prevIndex;
  float noiseVal = 0;
  float angleOffset;
  float noiseScale = 0.0004;
  float sizeMax;
  float rot;
  Particle(int index) {
    prevIndex = index - 1;
    pos = new PVector(width / 2, height / 2);
    spawn = pos;
    acc = new PVector(random(0.5, 0.9), random(0.5, 0.9));
    upwards = new PVector(0, -0.0125);
    angleOffset = acc.x * 0.03;
    sizeMax = acc.x * 52;
  }
  void move() {
    noiseVal += angleOffset;
    float angle = noise(pos.x * noiseScale, pos.y * noiseScale, noiseVal);
    if (prevIndex != -1) {
      PVector follow = upwards.copy().rotate(pos.dot(p[prevIndex].pos) / 10);
      pos.add(follow);
      pos.z = follow.x * 200;
      rot = atan2(p[prevIndex].pos.y - pos.y, p[prevIndex].pos.x - pos.x) / 10000;
      acc.rotate(rot);
      pos.add(upwards);
      acc.rotate(map(angle, 0, 1, -PI / 60, PI / 60));
      //pos.add(acc.copy().mult(0.5));
      pos.add(acc.copy().mult(norm(dist(pos.x, pos.y, p[prevIndex].pos.x, p[prevIndex].pos.y), 0, 50) + 0.3));    
      this.display(angle);
    }
  }
  void display(float angle) {
    //partCanvas.noStroke();
    //partCanvas.fill(angle * 300, 200, noise(angle) * 250, 20);
    float allow = dist(spawn.x, spawn.y, pos.x, pos.y);
    float newPosX = map(pos.x, 0, width, width, 0);
    float newPosY = map(pos.y, 0, height, height, 0);
    if (allow > 0.1) {
      partCanvas.pushMatrix();
      partCanvas.translate(pos.x, pos.y, pos.z);
      //partCanvas.rotate(atan2(pos.y - spawn.y, pos.x - spawn.x));
      //partCanvas.rotate(rot * 10000 * -1);
      partCanvas.rotate(acc.heading());
      partCanvas.image(sprite, 0, 0, angle * sizeMax, angle * sizeMax);
      partCanvas.popMatrix();      
      //this.checkPos();
      //partCanvas.image(sprite, pos.x, pos.y, angle * sizeMax, angle * sizeMax);
      //partCanvas.image(sprite, newPosX, pos.y, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
      //partCanvas.image(sprite, newPosX, newPosY, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
      //partCanvas.image(sprite, pos.x, newPosY, angle * sizeMax, map(angle, 0, 1, 1, 0) * sizeMax);
    }
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
  state = 1;
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
