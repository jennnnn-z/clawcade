// Clawcade
// Creates an animation from multiple images
// From https://processing.org/reference/libraries/#animation

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, images[frame].width * 4, images[frame].height * 4);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
