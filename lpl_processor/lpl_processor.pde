import processing.video.*;
Movie movie;

String moviePath = "sparkle.mov"; // name of your movie file in data folder

PGraphics screenCanvas;
int frameNum = 0;
float _scale;
float viewportWidth = 800;
float viewportHeight = 480;

void setup() {
  size(int(viewportWidth), int(viewportHeight));
  scale(_scale);
  background(0);

  movie = new Movie(this, moviePath);
  movie.play();
}

void draw() {
  if(screenCanvas == null && movie.width > 0){ // initialize the stuff
    // force video to display in the space we allow for it
    _scale = min(viewportWidth / movie.width, viewportHeight / movie.height);
    screenCanvas = createGraphics(int(movie.width), int(movie.height));
  }else{
    scale(_scale);
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
  if(screenCanvas != null) renderFrame();
}

void renderFrame() {
  print("\nrendering frame" + frameNum);

  movie.loadPixels();

  //TODO: create option for correctly rendering LIGHTEST by manually applying the values.

  screenCanvas.beginDraw();
  screenCanvas.blendMode(SCREEN); // Or LIGHTEST, but it fades out after a while. Probably a bug in Processing.
  screenCanvas.image(movie, 0, 0);
  screenCanvas.endDraw();

  frameNum++;
  screenCanvas.save("output/" + nfs(frameNum, 6) + ".png"); // or .tiff

  image(screenCanvas, 0, 0);
}
