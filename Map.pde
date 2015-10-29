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
     return x_/binSize + w*(y_/binSize);
   }
   
   // This function is used to return the bin at a particular XY position
   Bin get_bin(int x_, int y_) {
     return bins.get(xy_to_index(x_, y_));
   }
   
   void display() {
     stroke(100);
     strokeWeight(1);
     for (int i=0; i<=w; i++) {
       line(i*binSize, 0, i*binSize, height);
     }
     for (int i=0; i<=h; i++) {
       line(0, i*binSize, width, i*binSize);
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