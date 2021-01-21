int size = 800;
int w = 600;
int h = 600;

int screenX = 1000;
int screenY = 1000;
int nX = screenX/w;
int nY = screenY/h;
int border = 100;
int padX = 200;
int padY = 200;
int offX = nX/2 + padX;
int offY = nY/2 + padY;

color dark = color(55, 47, 24);
color light = color(224, 215, 184);
color blue = color(121, 164, 181);
color darkBlue = color(49, 87, 102);
color green = color(126, 183, 121);
color red = color(181, 121, 121);

float[][] terrain = new float[w + 1][h + 1];

void setup() {
  size(1000, 1000);
  noStroke();
  smooth(2);
    
  noiseDetail(10, 0.4f);
  noiseSeed(268231);
  
  background(light);
  
  for (int i = 0; i < w; i++)
    for (int j = 0; j < h; j++)
      terrain[i][j] = GetNoise(i, j);
  
  GenerateTerrain();

  DrawOverlayLines();
  
  //save("Map " + random(5) + ".png");
}

void GenerateTerrain(){

  for (int i = 1; i < w ; i++) {
    for (int j = 1; j < h; j++) {
      
      float h = terrain[i][j];
      
      if(h < 50f)
        fill(lerpColor(darkBlue, blue, map(h, 0, 50, 0, 1)));
      else if(h < 200f)
        fill(lerpColor(green, light, map(h, 0, 255, 0, 1)));
      else
        fill(lerpColor(light, color(255), map(h, 200, 255, 0, 1)));
      
      square(i * nX + offX, j * nY + offY, 1);
      
      if(h >= 50 && GetMaxHeightDrop(i, j) > 0.25f && h % 10 == 0){
        fill(color(dark, h));
        square(i * nX + offX, j * nY + offY, 1);
      }
      
    }
  }
}

float distSqrt(float x1, float y1, float x2, float y2){
  return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
}

float GetMaxHeightDrop(int x, int y){
  float hD = -999999f;
  
  float h = terrain[x][y];
  
  for(int i = -1; i <= 1; i++) {
    for(int j = -1; j <= 1; j++) {
      float dy = h - terrain[x + i][ y + j];
      if(dy > 0)
        hD = max(dy, hD);
    }
  }
  
  return hD;
}

void DrawOverlayLines(){
  stroke(color(dark, 5));
  
  int interval = 50;
  for(int i = 0; i <= (w/interval); i++){
    for(int j = 0; j <= (h/interval); j++){
      line(padX + i * interval, padX, padY + i * interval, screenY-padY);
      line(padX, padY + j * interval, screenX - padX, padY + j * interval);
    }
  }
}

float GetNoise(float x, float y){
  //float scl = 0.003f;
  float scl = 0.006f;
  //float scl = 0.008f;
  
  //float mountains = noise(x*scl*2, y*scl*2) * 128;
  //float hills = noise(x*scl*8, y*scl*8) * 64;
  //float rocks = noise(x*scl*15, y*scl*15) * 7;
  //float pebbles = random(0.1f);
  
  float quantize = 1;
  float noise = noise(x*scl, y * scl);
  float regularNoise = map(noise, 0, 1, 0, 255);
  float ridgedNoise = map(2 * (0.5f - abs(0.5 - noise)), 0, 1, 0, 255);
  float expNoise = map(pow(noise, 1.25f), 0, 1, 0, 255);
  float quantizedNoise = float(round(expNoise*quantize))/quantize;
  return quantizedNoise;
}

class Layer{
  ArrayList<PVector> points;
  ArrayList<ArrayList<PVector>> shapes;
  float elevation;
  
  public Layer(float elevation){
    this.elevation = elevation;
    this.points = new ArrayList<PVector>();
    this.shapes = new ArrayList<ArrayList<PVector>>();
  }
  
  public void Add(PVector point){
    points.add(point);
  }
}
