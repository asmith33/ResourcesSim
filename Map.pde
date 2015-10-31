class Map {
  /*
   *
   */
  int w; // width
  int h; // height
  int binSize; // determines the size of the map subsections
  Grid grid; // This object stores a collection of bins

  Map (int width_, int height_, int binSize_) {
    w = width_;
    h = height_;
    binSize = binSize_;
    grid = new Grid(w, h, binSize);
  }
}

class Grid {
  /*
   *
   */
  int w; // grid width (in bins)
  int h; // grid height (in bins)
  int binSize;
  List<Bin> bins; // a collection of bins

  Grid (int width_, int height_, int binSize_) {
    binSize = binSize_;
    w = width_/binSize;
    h = height_/binSize;
    bins = new ArrayList();
    for (int i=0; i<w*h; i++) {
      bins.add(new Bin(4, i));
    }
  }

  // This function takes in an actual x,y position and converts it to bin index
  int xy_to_index(int x_, int y_) {
    // This was causing IndexOutOfBoundsException errors
    if (x_ < 0 || x_ >= width || y_ < 0 || y_ >= height) {
      // Using -1 as an error code.
      println("xy_to_index error " + x_, y_);
      return -1;
    } else { 
      return x_/binSize + w*(y_/binSize);
    }
  }

  // This function is used to return the bin at a particular XY position
  Bin get_bin(int x_, int y_, int debug) {
    // Storing this first to check for -1
    int i = xy_to_index(x_, y_);
    if (i==-1) {
      println("get_bin error " + debug);
      // -1 is bad
      //println("Out of bounds call for get_bin()");
      // TODO THIS RETURN IS REALLY BAD. DONT MAKE MORE BINS!
      return new Bin(4, -1);
    } else {
      return bins.get(xy_to_index(x_, y_));
    }
  }
  


  void display() {
    /* This worked well, just wanted to try making boxes that represent the values by color
     stroke(100);
     strokeWeight(1);
     for (int i=0; i<=w; i++) {
     line(i*binSize, 0, i*binSize, height);
     }
     for (int i=0; i<=h; i++) {
     line(0, i*binSize, width, i*binSize);
     }
     */
    for (int i=0; i<w*h; i++) {
      Bin b = bins.get(i);
      noStroke();
      fill(map(b.energies.get(0), 0, ra.max_per_bin, 0, 255), map(b.energies.get(1), 0, rb.max_per_bin, 0, 255), map(b.energies.get(2), 0, rc.max_per_bin, 0, 255), 100);
      
      //if (float (width/binSize) = 0.0) {
      //  rect( (i*binSize)%(w*binSize), i/binSize, binSize, binSize);
      //} else {
        rect( (i*binSize)%(w*binSize), i*binSize/w, binSize, binSize);
      //}
    }
  }
}

class Bin {
  /*
   *
   */
  int index;
  ArrayList<Float> energies;

  Bin (int number_of_energies, int index_) {
    index = index_;
    // Each bin will store the energy levels for each type of energy seperatly.
    energies = new ArrayList();
    for (int i=0; i<number_of_energies; i++) {
      energies.add(0.0);
    }
  }
}