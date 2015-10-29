class Agent {
  float energy;
  float harvest_rate_a, harvest_rate_b, harvest_rate_c, harvest_rate_d;
  int x, y;
  int vx, vy;
  int wind_max;
  int wind;
  float spawn_rate = .001;
  float mutation_rate = .5;
  float mutation_increment = 5;

  Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm) {
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
  }

  void harvest(int harv_type) {
    float delta_e=0;

    if (harv_type == 0) {
      delta_e = harvest_rate_a*map.grid.get_bin(x, y).energies.get(0);
      energy = energy + delta_e;
      map.grid.get_bin(x,y).energies.set(0, map.grid.get_bin(x,y).energies.get(0)-delta_e);
    } /*else if (harv_type == 1) {
      delta_e = harvest_rate_b*map.grid.get_bin(x, y).energies.get(1);
      energy = energy + delta_e;
      b.energies.set(1, b.energies.get(1)-delta_e);
    } else if (harv_type == 2) {
      delta_e = harvest_rate_c*map.grid.get_bin(x, y).energies.get(2);
      energy = energy + delta_e;
      b.energies.set(2, b.energies.get(2)-delta_e);
    } else if (harv_type == 3) {
      delta_e = harvest_rate_d*map.grid.get_bin(x, y).energies.get(3);
      energy = energy + delta_e;
      b.energies.set(3, b.energies.get(3)-delta_e);
    }*/
  }

  void move() {
    if (millis()%4==0) {
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
    }
    energy--;
  }

  void display() {
    noStroke();
    fill(map(harvest_rate_b, 0, .3, 105, 245), map(harvest_rate_a, 0, .3, 105, 245), map(harvest_rate_c, 0, .3, 105, 245));
    ellipse(x, y, 8, 8);
  }

  Agent mutate_reproduce() {
    float rnd = random(1);

    float pass_ha = harvest_rate_a;
    float pass_hb = harvest_rate_b;
    float pass_hc = harvest_rate_c;
    float pass_hd = harvest_rate_d;
    int pass_mw = wind_max;

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
    }
    if (pass_ha < 1 || pass_hb < 1 || pass_hc < 1 || pass_hd < 1) {
      pass_ha = harvest_rate_a;
      pass_hb = harvest_rate_b;
      pass_hc = harvest_rate_c;
      pass_hd = harvest_rate_d;
    }
    Agent a = new Agent(x+rand_three()-2, y+rand_three()-2, pass_ha, pass_hb, pass_hc, pass_hd, pass_mw);
    return a;
  }
}