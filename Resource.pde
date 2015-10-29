class Resource {

  int type; // 0:resource_a, 1:resource_b, 2:resource_c, 3:resource_d
  int radius;
  int x, y;
  int vx, vy;
  float growth_rate;
  float decay_rate;
  int max_per_bin;
  
  Resource(int type_, int radius_, int x_, int y_, int vx_, int vy_, float growth_rate_, float decay_rate_, int max_per_bin_) {
    type = type_;
    radius = radius_;
    x = x_;
    y = y_;
    vx = vx_;
    vy = vy_;
    growth_rate = growth_rate_;
    decay_rate = decay_rate_;
    max_per_bin = max_per_bin_;
  }

  void replenish() {
    for (int i=x-radius; i<= x+radius; i=i+map.binSize) {
      for (int j=y-radius; j<= y+radius; j=j+map.binSize) {
        if (isWithin(i+map.binSize/2,j+map.binSize/2)) {
          Bin b = map.grid.get_bin(i,j);
          if (type==0) {
            Float e = b.energies.get(0);
            e = e + (max_per_bin - e)*growth_rate;
            b.energies.set(0,e);
          }
        }
      }
    }
  }
  
  void move() {
    switch(type) {
      case 0:
        if (x+vx+radius > width || x+vx-radius < 0) {
        vx=-vx;
      } else if (y+vy+radius > height || y+vy-radius < 0) {
        vy=-vy;
      } 
      
      x = x + vx;
      y = y + vy;
      break;
    }
  }
  
  boolean isWithin(int their_x, int their_y) {
    /*
     * This function checks to see if an x/y position is within the radius of this object
     */
    float dist = (x - their_x)*(x - their_x) + (y - their_y)*(y - their_y);
    if (dist < radius*radius) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    strokeWeight(1);
    stroke(0);
    if (type == 0) {
      fill(57, 240, 65, 30);
    } else if (type == 1) {
      fill(200, 10, 25, 30);
    } else if (type == 2) {
      fill(0, 55, 214, 30);
    } else if (type == 3) {
      fill(230, 100);
    }
    
    ellipse(x, y, 2*radius, 2*radius);
  }

}