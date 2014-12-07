import processing.video.*;
Movie movie;

String moviePath = "sparkle.mov"; // name of your movie file in data folder
int blendMode = SCREEN; // SCREEN or LIGHTEST

PGraphics canvas;
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
  if(canvas == null && movie.width > 0){ // initialize the stuff
    // force video to display in the space we allow for it
    _scale = min(viewportWidth / movie.width, viewportHeight / movie.height);
    canvas = createGraphics(int(movie.width), int(movie.height));
    canvas.beginDraw(); // populating pixel array
    canvas.background(0);
    canvas.endDraw();
  }else{
    scale(_scale);
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
  if(canvas != null) renderFrame();
}

void renderFrame() {
  print("\nrendering frame" + frameNum);

  movie.loadPixels();

  if(blendMode == SCREEN){

    canvas.beginDraw();
    canvas.blendMode(blendMode);
    canvas.image(movie, 0, 0);
    canvas.endDraw();
 
  }else if(blendMode == LIGHTEST){
    
    // built-in LIGHTEST blend mode slowly fades out the image (it shouldn't), so we are doing this the hard way
  
    for (int i = 0; i < movie.pixels.length; i++) {
      
      color canvasColor = canvas.pixels[i];
      color frameColor = movie.pixels[i];
      
      // Luminance (perceived): (0.299*R + 0.587*G + 0.114*B)
      int cr = (canvasColor >> 16) & 0xff;
      int cg = (canvasColor >> 8 ) & 0xff;
      int cb = canvasColor & 0xff;
      int fr = (frameColor >> 16) & 0xff;
      int fg = (frameColor >> 8 ) & 0xff;
      int fb = frameColor & 0xff;
      
      float canvasLum = cr * .299 + cg * .587 + cb * .144;
      float frameLum = fr * .299 + fg * .587 + fb * .144;
      
      if(frameLum > canvasLum){
        canvas.pixels[i] = frameColor;
      }  
    }
    canvas.updatePixels();
  }

  frameNum++;
  canvas.save("output/" + nfs(frameNum, 6) + ".png"); // or .tiff

  image(canvas, 0, 0);
}
