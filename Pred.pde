class Pred {
  float energy;
  float harvest_rate_a, harvest_rate_b, harvest_rate_c, harvest_rate_d;
  int x, y;
  int vx, vy;
  int wind_max;
  int wind;
  float spawn_rate = .0800;
  float mutation_rate = .3;
  float mutation_increment = .025;
  int rest_count_max;
  int rest_count;
  int since_last_meal;
  int age;
  float largest_harvest_rate=0;
  int largest_harvest_rate_type=0;
 

  Pred(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
    x = x_;
    y = y_;
    vx = 0;
    vy = 0;
    harvest_rate_a = ha;
    harvest_rate_b = hb;
    harvest_rate_c = hc;
    harvest_rate_d = hd;
    //wind_max = wm;
    wind_max = 2;
    wind = wind_max;
    energy = 500;
    rest_count_max = rest_count_max_;
    rest_count = rest_count_;
    since_last_meal = 0;
    age = 0;
  }

  float hunt() {
    if (x>=0 && x<width && y>=0 && y<height) {
      
      // Only going to use the predators highest harvest_rate to determine attack strength
      largest_harvest_rate = harvest_rate_a;
      largest_harvest_rate_type = 0;
      if (harvest_rate_b > largest_harvest_rate) {
        largest_harvest_rate = harvest_rate_b;
        largest_harvest_rate_type = 1;
      }
      if (harvest_rate_c > largest_harvest_rate) {
        largest_harvest_rate = harvest_rate_c;
        largest_harvest_rate_type = 2;
      }
      if (harvest_rate_d > largest_harvest_rate) {
        largest_harvest_rate = harvest_rate_d;
        largest_harvest_rate_type = 3;
      }
      
      // Finding out which bin this predator is currently living in
      int i = map.grid.xy_to_index(x,y);
      
      // Go through all the agents in this bin and attempt to hunt
      // if hunt is successful, do not hunt the others
      Collection<Integer> agents_near = water_holes.get(i);
      
      for (Integer j : agents_near) {
        Agent a = agents.get(j);
        
        // Determine the attack strength
        float attack=0;
        if (largest_harvest_rate_type == 0) {
          attack = a.harvest_rate_a*largest_harvest_rate;
        } else if (largest_harvest_rate_type == 1) {
          attack = a.harvest_rate_b*largest_harvest_rate;
        } else if (largest_harvest_rate_type == 2) {
          attack = a.harvest_rate_c*largest_harvest_rate;
        } else if (largest_harvest_rate_type == 3) {
          attack = a.harvest_rate_d*largest_harvest_rate;
        }
        
        // Allow predator to adapt to a new food source
        if (a.find_largest_harvest_rate_type() == 0) {
          adapt(0);
        } else if (a.find_largest_harvest_rate_type() == 1) {
          adapt(1);
        } else if (a.find_largest_harvest_rate_type() == 2) {
          adapt(2);
        } else if (a.find_largest_harvest_rate_type() == 3) {
          adapt(3);
        }
        
        // making this random number smaller will increase the likelyhood of a successful hunt
        float rnd = random(.60);
        //if (.1 > rnd) {
        if (attack > rnd) {
          // Succesful hunt
          no_energy.add(j);
          since_last_meal = 0;
          energy += a.energy;
          
          // chance to reproduce within life window
          // taking out the upper bound energy < 400
          // going to try and stop early reproduction with a variable called "age"
          if (energy > 200 && age > 150) {
            float rnd_repro = random(1);
            if (rnd_repro < spawn_rate) {
              //println("A predator has reproduced");
              preds.add(mutate_reproduce());
            }
          }
          return a.energy;
        }
      }
    } 
    since_last_meal++;
    return 0.0;
  }
      
   

  void move() {
    age++;
    rest_count++;
    //if (rest_count >= rest_count_max) {
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
      
      // Time to eat
      hunt();
      
      // trying to build in a penalty for going hungry. Too many are breeding in areas where there isn't even any food.
      energy = energy - since_last_meal - 25;

    //} else {
      return;
    //}
    
            
  }
  void adapt(int resource) {
    
    // Making temp variables so that I can check for negative numbers before applying to the predator
    float new_a = harvest_rate_a;
    float new_b = harvest_rate_b;
    float new_c = harvest_rate_c;
    float new_d = harvest_rate_d;
    
    int rand = rand_three();
    
    // Going to increase the harvest rate that 
    if (resource != largest_harvest_rate_type) {
      switch (resource) {
        case 0:
          new_a += .005;
          if (rand == 1) {
            new_b -= .005;
          } else if (rand == 2) {
            new_c -= .005;
          } else {
            new_d -= .005;
          }
          break;
        case 1:
          new_b += .005;
          if (rand == 1) {
            new_a -= .005;
          } else if (rand == 2) {
            new_c -= .005;
          } else {
            new_d -= .005;
          }
          break;
        case 2:
          new_c += .005;
          if (rand == 1) {
            new_a -= .005;
          } else if (rand == 2) {
            new_b -= .005;
          } else {
            new_d -= .005;
          }
          break;
        case 3:
          new_d += .005;
          if (rand == 1) {
            new_a -= .005;
          } else if (rand == 2) {
            new_b -= .005;
          } else {
            new_c -= .005;
          }
          break;
      }
    }
    
    // checking to make sure no harvest rate went negative, then applying change
    if (new_a >= 0 && new_b >= 0 && new_c >= 0 && new_d >= 0) {
      harvest_rate_a = new_a;
      harvest_rate_b = new_b;
      harvest_rate_c = new_c;
      harvest_rate_d = new_d;
    }
  }
        
        

  void display() {
    noStroke();
    //fill(map(harvest_rate_a, 0, .225, 0, 255), map(harvest_rate_b, 0, .225, 0, 255), map(harvest_rate_c, 0, .225, 0, 255), 35+(255*energy)/500);
    fill(255);
    ellipse(x, y, 6, 6);
    float sum_harvest_rate = harvest_rate_a + harvest_rate_b + harvest_rate_c + harvest_rate_d;
    fill(map(harvest_rate_a, 0, sum_harvest_rate, 0, 255), map(harvest_rate_b, 0, sum_harvest_rate, 0, 255), map(harvest_rate_c, 0, sum_harvest_rate, 0, 255), 135+(255*energy)/500);
    ellipse(x, y, 5, 5);
  }

  Pred mutate_reproduce() {
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
    Pred p = new Pred(x+rand_three()-2, y+rand_three()-2, pass_ha, pass_hb, pass_hc, pass_hd, pass_mw, pass_rcm, pass_rcm);
    return p;
  }
}