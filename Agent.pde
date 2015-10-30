class Agent {
  float energy;
  float harvest_rate_a, harvest_rate_b, harvest_rate_c, harvest_rate_d;
  int x, y;
  int vx, vy;
  int wind_max;
  int wind;
  // spaw rate of .08 is nice, maybe a tad slow
  // spawn rate of .09 snowballs with no end in sight
  float spawn_rate = .0225;
  float mutation_rate = .3;
  float mutation_increment = .025;
  int rest_count_max;
  int rest_count;
  int since_last_meal;
  int age;
 

  Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
    x = x_;
    y = y_;
    vx = 0;
    vy = 0;
    harvest_rate_a = ha;
    harvest_rate_b = hb;
    harvest_rate_c = hc;
    harvest_rate_d = hd;
    wind_max = wm;
    wind = wind_max;
    energy = 500;
    rest_count_max = rest_count_max_;
    rest_count = rest_count_;
    since_last_meal = 0;
    age = 0;
  }

  float harvest(int harv_type) {
    if (x < 0 || y < 0 || x > width || y > height) {
      return 0.0;
    }
      
    float delta_e=0;

    if (harv_type == 0) {
      // Grab the bin, energy a = 0
      Float available_quantity = map.grid.get_bin(x,y, 0).energies.get(0);
      // The change in this agents energy is equal to their harvest rate multiplied by 
      // the ratio of the remaining energy.
      delta_e = harvest_rate_a*(available_quantity*available_quantity/ra.max_per_bin);
      // Updating this agents energy
      energy = energy + delta_e;
      // Setting the grid to reflect the reduction in energy
      map.grid.get_bin(x,y, 1).energies.set(0, available_quantity-delta_e);
    } else if (harv_type == 1) {
      Float available_quantity = map.grid.get_bin(x,y, 2).energies.get(1);
      delta_e = harvest_rate_b*(available_quantity*available_quantity/rb.max_per_bin);
      energy = energy + delta_e;
      map.grid.get_bin(x,y, 3).energies.set(1, available_quantity-delta_e);
    } else if (harv_type == 2) {
      Float available_quantity = map.grid.get_bin(x,y, 4).energies.get(2);
      delta_e = harvest_rate_c*(available_quantity*available_quantity/rc.max_per_bin);
      energy = energy + delta_e;
      map.grid.get_bin(x,y, 5).energies.set(2, available_quantity-delta_e);
    } /*else if (harv_type == 3) {
      Float available_quantity = map.grid.get_bin(x,y).energies.get(3);
      delta_e = harvest_rate_d*(available_quantity*available_quantity/rd.max_per_bin);
      energy = energy + delta_e;
      map.grid.get_bin(x,y).energies.set(3, available_quantity-delta_e);
    }*/
    return delta_e;
  }

  void move() {
    age++;
    rest_count++;
    if (rest_count >= rest_count_max) {
      rest_count = 0;
    
      if (wind == 0) { 
        // The object has reached the end of it's gas tank and will either rest, or move
        // in a new direction. 
        wind = wind_max;
        // This will make the new (x or y) velocity -1, 0, 1 33% of the time. 
        vx = rand_three() - 2;
        vy = rand_three() - 2;
      } else {
        wind--;
      }
  
      x = x + vx;
      y = y + vy;
      // trying to build in a penalty for going hungry. Too many are breeding in areas where there isn't even any food.
      energy = energy - since_last_meal - 1;
      
      // chance to reproduce within life window
      // taking out the upper bound energy < 400
      // going to try and stop early reproduction with a variable called "age"
      if (energy > 200 && age > 150) {
        float rnd = random(1);
        if (rnd < spawn_rate) {
          agents.add(mutate_reproduce());
       }
    }
    } else {
      return;
    }
    
    
    
    // time to eat.
    float y = harvest(0);
    y += harvest(1);
    y += harvest(2);
    if (y<2) {
      since_last_meal++;
    } else {
      since_last_meal = 0;
    }
    
  }

  void display() {
    noStroke();
    fill(map(harvest_rate_a, 0, .25, 30, 220), map(harvest_rate_b, 0, .225, 30, 220), map(harvest_rate_c, 0, .225, 30, 220));
    ellipse(x, y, 5, 5);
  }

  Agent mutate_reproduce() {
    float rnd = random(1);

    float pass_ha = harvest_rate_a;
    float pass_hb = harvest_rate_b;
    float pass_hc = harvest_rate_c;
    float pass_hd = harvest_rate_d;
    int pass_mw = wind_max;
    int pass_rcm = rest_count_max;

    if (rnd < mutation_rate) {
      /*
       * A mutation has happened. Going to keep total harvesting power equal.
       */
      int r = rand_four();
      if (r==1) {
        pass_ha = harvest_rate_a + mutation_increment;
        float q = rand_three();
        if (q == 1) {
          pass_hb = harvest_rate_b - mutation_increment;
          pass_hc = harvest_rate_c;
          pass_hd = harvest_rate_d;
        } else if (q == 2) {
          pass_hb = harvest_rate_b;
          pass_hc = harvest_rate_c - mutation_increment;
          pass_hd = harvest_rate_d;
        } else {
          pass_hb = harvest_rate_b;
          pass_hc = harvest_rate_c;
          pass_hd = harvest_rate_d - mutation_increment;
        }
      } else if (r==2) {
        pass_hb = harvest_rate_b + mutation_increment;
        float q = rand_three();
        if (q == 1) {
          pass_ha = harvest_rate_a - mutation_increment;
          pass_hc = harvest_rate_c;
          pass_hd = harvest_rate_d;
        } else if (q == 2) {
          pass_ha = harvest_rate_a;
          pass_hc = harvest_rate_c - mutation_increment;
          pass_hd = harvest_rate_d;
        } else {
          pass_ha = harvest_rate_a;
          pass_hc = harvest_rate_c;
          pass_hd = harvest_rate_d - mutation_increment;
        }
      } else if (r==3) {
        pass_hc = harvest_rate_c + mutation_increment;
        float q = rand_three();
        if (q == 1) {
          pass_ha = harvest_rate_a - mutation_increment;
          pass_hb = harvest_rate_b;
          pass_hd = harvest_rate_d;
        } else if (q == 2) {
          pass_ha = harvest_rate_a;
          pass_hb = harvest_rate_b - mutation_increment;
          pass_hd = harvest_rate_d;
        } else {
          pass_ha = harvest_rate_a;
          pass_hb = harvest_rate_b;
          pass_hd = harvest_rate_d - mutation_increment;
        }
      } else if (r==4) {
        pass_hd = harvest_rate_d + mutation_increment;
        float q = rand_three();
        if (q == 1) {
          pass_ha = harvest_rate_a - mutation_increment;
          pass_hb = harvest_rate_b;
          pass_hc = harvest_rate_c;
        } else if (q == 2) {
          pass_ha = harvest_rate_a;
          pass_hb = harvest_rate_b - mutation_increment;
          pass_hc = harvest_rate_c;
        } else {
          pass_ha = harvest_rate_a;
          pass_hb = harvest_rate_b;
          pass_hc = harvest_rate_c - mutation_increment;
        }
      }

      if (coin_flip() && wind_max > 1) {
        if (coin_flip()) {
          pass_mw = wind_max-1;
        } else {
          pass_mw = wind_max+1;
        }
      }
      
      if (coin_flip()) {
        pass_rcm = rest_count_max + 1;
      } else if (rest_count_max > 1) {
        pass_rcm = rest_count_max - 1;
      }
      
    }
    if (pass_ha < 0 || pass_hb < 0 || pass_hc < 0 || pass_hd < 0) {
      pass_ha = harvest_rate_a;
      pass_hb = harvest_rate_b;
      pass_hc = harvest_rate_c;
      pass_hd = harvest_rate_d;
    }
    Agent a = new Agent(x+rand_three()-2, y+rand_three()-2, pass_ha, pass_hb, pass_hc, pass_hd, pass_mw, pass_rcm, pass_rcm);
    return a;
  }
}