Particle [] p;
PGraphics partCanvas;
PShader shade;
PImage sprite, tex;
int state = 0;
int DIR () {
  int [] d = {-1, 1};
  return d[floor(random(d.length))];
}

void settings() {
  size(1200, 900, P3D);
  //pjogl = (PJOGL)this.beginPGL();
  PJOGL.profile = 4;
  //hint(ENABLE_DEPTH_SORT);
}
int count = 0;

void setup() {
  smooth(8);
  background(0);
  frameRate(1000);
  partCanvas = createGraphics(width, height, P3D);
  shade = loadShader("brcosa6.frag");
  sprite = loadImage("sprite.png");
  tex = loadImage("Capture1.png");
  p = new Particle[1510];
  for (int i = 0; i < p.length; i ++) {
    p[i] = new Particle(i);
    count++;
  }
  partCanvas.beginDraw();
  partCanvas.blendMode(SCREEN);
  partCanvas.endDraw();
}
float smooth = 0.11;
void draw() {
  surface.setTitle(str(round(frameRate)));
  //background(0);
  //shade.set("texture2", partCanvas);
  partCanvas.beginDraw();
  partCanvas.background(0, 20);
  //partCanvas.rect(0, 0, width, height);
  partCanvas.shader(shade);
  for (Particle p : p) {
    p.move();
  }
  partCanvas.endDraw();
  //shader(shade);
  //tint(255, 10);
  image(partCanvas, 0, 0);
  //saveFrame();
}



class Particle {
  PVector pos, acc, spawn, upwards;
  int prevIndex;
  float noiseVal = 0;
  float angleOffset;
  float noiseScale = 0.004;
  float sizeMax;
  Particle(int index) {
    prevIndex = index - 1;
    pos = new PVector(width / 2, height / 2);
    spawn = pos;
    acc = new PVector(random(0.5, 0.8), random(0.5, 0.8));
    upwards = new PVector(0, -0.25);
    angleOffset = acc.x * 0.0003;
    sizeMax = acc.x * 22;
  }
  void move() {
    noiseVal += angleOffset;
    float angle = noise(pos.x * noiseScale, pos.y * noiseScale, noiseVal);
    if (prevIndex != -1 && prevIndex + 2 != count) {
      PVector follow = acc.copy().rotate(pos.dot(p[prevIndex].pos));
      PVector follow2 = acc.copy().rotate(pos.dot(p[prevIndex + 2].pos));
      //PVector follow = upwards.copy().rotate(p[prevIndex].pos.heading());
      pos.z = follow.x * 200;
      float rot = atan2(p[prevIndex].pos.y - pos.y, p[prevIndex].pos.x - pos.x) / 1000;
      //float rot = PVector.angleBetween(follow, follow2) / 1000;
      acc.rotate(map(angle, 0, 1, -PI / 120, PI / 120));
      acc.rotate(rot / 2);
      pos.add(upwards);
      pos.add(acc.copy().cross(follow, follow2));
      //pos.add(follow2);
      pos.add(acc.copy().
        mult(
        norm(
        dist(
        pos.x, pos.y, p[prevIndex].pos.x, p[prevIndex].pos.y), 0, 160) + 0.63));
      this.display(angle);
    }
  }
  void display(float angle) {
    //partCanvas.noStroke();
    //partCanvas.fill(angle * 300, 200, noise(angle) * 250, 20);
    float allow = dist(spawn.x, spawn.y, pos.x, pos.y);
    float newPosX = map(pos.x, 0, width, width, 0);
    float newPosY = map(pos.y, 0, height, height, 0);
    sizeMax = dist(0, 0, spawn.x, spawn.y) / 40;
    if (allow > 2) {
      partCanvas.pushMatrix();
      partCanvas.translate(pos.x, pos.y);
      //partCanvas.rotate(atan2(pos.y - spawn.y, pos.x - spawn.x));
      //partCanvas.rotate(rot * 10000 * -1);
      partCanvas.rotate(acc.heading());
      partCanvas.image(sprite, 0, 0, sizeMax, sizeMax);
      partCanvas.popMatrix();    
      partCanvas.pushMatrix();
      partCanvas.translate(newPosX, pos.y);
      //partCanvas.rotate(atan2(pos.y - spawn.y, pos.x - spawn.x));
      //partCanvas.rotate(rot * 10000 * -1);
      PVector adjustment = acc.copy();
      adjustment.x *= -1;
      partCanvas.rotate(adjustment.heading());
      partCanvas.image(sprite, 0, 0, sizeMax, sizeMax);
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
