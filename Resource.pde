class Resource {

  int type; // 0:resource_a, RED, 1:resource_b, GREEN, 2:resource_c, BLUE, 3:resource_d
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
          // Was having a problem where I was trying to index bins.. I thought it was because I was calling -x's or -y's.. but maybe not.. the plot thickens.
          // By god i've solved it. I was checking x/y.. but im using i,j in the function call. doh!
          if (i >= 0 && j >= 0 && i < width && j < height) {  
            Bin b = map.grid.get_bin(i,j, 6);
            if (type==0) {
              Float e = b.energies.get(0);
              e = e + (max_per_bin - e)*growth_rate;
              b.energies.set(0,e);
            } else if (type==1) {
              Float e = b.energies.get(1);
              e = e + (max_per_bin - e)*growth_rate;
              b.energies.set(1,e);
            } else if (type==2) {
              Float e = b.energies.get(2);
              e = e + (max_per_bin - e)*growth_rate;
              b.energies.set(2,e);
            }
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
          vy=-vy;
        } 
        if (y+vy+radius > height || y+vy-radius < 0) {
          vy=-vy;
          vx=-vx;
        }
        
        x = x + vx;
        y = y + vy;
        
        
        break;
      case 1:
        if (x+vx+radius > width || x+vx-radius < 0) {
          vx=-vx;
        } 
        if (y+vy+radius > height || y+vy-radius < 0) {
          vy=-vy;
        }
        /*
        // This makes the dude a random walker
        if (x < width - 5 && x > 5 && y > 5 && y < height -5 && int(millis()%75)==0) {
          float r = random(1);
          if (r > .5) {
            vx = - vx;
          }
          r = random(1);
          if (r > .5) {
            vy = -vy;
          }
        }
        */  
        x = x + vx;
        y = y + vy;
        
        
        break;
      case 2:
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
      fill(200, 10, 25, 30);
    } else if (type == 1) {
      fill(57, 240, 65, 30);
    } else if (type == 2) {
      fill(0, 55, 214, 30);
    } else if (type == 3) {
      fill(230, 100);
    }
    
    if (hide_grid && !hide_resources) {
      ellipse(x, y, 2*radius, 2*radius);
    }
  }

}