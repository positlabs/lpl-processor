import processing.video.*;
Movie movie;

String moviePath = "sparkle.mov"; // name of your movie file in data folder
int WIDTH = 1920; // needs to match the movie!!!
int HEIGHT = 1080; // needs to match the movie!!!
String frameType = ".png"; // or .tiff?

PGraphics screenCanvas;
int frameNum = 0;
float _scale;

void setup() {
  float viewportWidth = 800;
  float viewportHeight = 480;
  size(int(viewportWidth), int(viewportHeight));

  // force video to display in the space we allow for it
  float sx = viewportWidth / WIDTH;
  float sy = viewportHeight / HEIGHT;
  _scale = min(sx, sy);
  scale(_scale);

  background(0);

  screenCanvas = createGraphics(int(WIDTH), int(HEIGHT));
  movie = new Movie(this, moviePath);
  movie.play();
}

void draw() {
  scale(_scale);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
  renderFrame();
}

void renderFrame() {
  print("\nrendering frame" + frameNum);

  movie.loadPixels();

  screenCanvas.beginDraw();
  screenCanvas.blendMode(SCREEN); // Or LIGHTEST, but it fades out after a while. Probably a bug in Processing.
  screenCanvas.image(movie, 0, 0);
  screenCanvas.endDraw();

  frameNum++;
  screenCanvas.save("output/" + nfs(frameNum, 6) + frameType);

  image(screenCanvas, 0, 0);
}
