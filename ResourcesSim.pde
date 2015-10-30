import java.util.*;
import toxi.geom.*;
import com.google.common.collect.*;

/* 
 * Keyboard Inputs:
 * 'a' hide_agents (toggle)
 * 'w' hide_window (toggle)
 * 'g' hide_grid (toggle)
 * 'p' hide_predators (toggle)
 * 'c' hide_resources (toggle)
 */



Map map;
Window win;
Resource ra, rb, rc, re, rf, rg, rh, ri, rj, rk;
ArrayList<Agent> agents;
ArrayList<Pred> preds;

boolean hide_agents, hide_grid=true, hide_resources=true, hide_window=true, hide_preds;
Multimap<Integer, Integer> water_holes;
ArrayList<Integer> no_energy;

void setup() {
  size(1000, 600, P2D);
  win = new Window();
  map = new Map(width, height, 8);
  //Resource(int type_, int radius_, int x_, int y_, int vx_, int vy_, float growth_rate_, float decay_rate_, int max_per_bin_) {
  ra = new Resource(0, 100, width/2, height/2, 0, 0, .008, 0, 10); // red (center)
  rb = new Resource(1, 100, 100, height - 100, 1, 0, .015, 0, 10); // green (bottom mover)
  rc = new Resource(2, 300, width/2, height/2, 0, 0, .007, 0, 10); // blue (center)
  re = new Resource(0, 100, 100, height/2, 1, -1, .012, 0, 10); // red (top left mover)
  rf = new Resource(2, 80, 80, 80, 0, 0, .007, 0, 10); // blue (top left)
  rg = new Resource(2, 80, width-80, 120, 0, 0, .007, 0, 10); // blue (top right)
  rh = new Resource(1, 100, 625, 125, 0, 0, .008, 0, 10); // green (right center)
  ri = new Resource(0, 50, width-50, height-50, 0, 0, .007, 0, 10); // red (bottom left)
  rj = new Resource(2, 50, width-150, height-53, 1, -3, .012, 0, 10); // blue (bottom mover)
  rk = new Resource(1, 100, width-100, height-100, -1, 0, .015, 0, 10); // green (bottom mover)
  
  agents = new ArrayList();
  for (int i=0; i<width/2; i++) {
    for (int j=0; j<1; j++) {
      //Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
      agents.add(new Agent(i+width/4, height/2, .175, .1625, .1625, .00, 1, int(random(8)), int(millis())%5));
    }
  }
  for (int i=0; i<width; i++) {
    for (int j=0; j<1; j++) {
      //Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
      //agents.add(new Agent(i, height/4, .1, .275, .125, .00, 1, int(random(8)), int(millis())%5));
    }
  }
  
  preds = new ArrayList();
}

void draw() {
  background(55);
  surface.setTitle(round(frameRate) + " fps || agents " + agents.size() + " || predators " + preds.size() + " || total " + (agents.size()+preds.size()));
  if (!hide_grid) { map.grid.display(); }
  ra.move();
  rb.move();
  rc.move();
  re.move();
  rf.move();
  rg.move();
  //rh.move();
  ri.move();
  rj.move();
  rk.move();
  ra.replenish();
  rb.replenish();
  rc.replenish();
  re.replenish();
  rf.replenish();
  rg.replenish();
  rh.replenish();
  ri.replenish();
  rj.replenish();
  rk.replenish();
  ra.display();
  rb.display();
  rc.display();
  re.display();
  rf.display();
  rg.display();
  rh.display();
  ri.display();
  rj.display();
  rk.display();
  
  // This hashtable is going to map bin index to agent index in the agents list.
  // Important to not change the index of the agents list before using this dictionary
  water_holes = ArrayListMultimap.create();
  
  
  // Need a way to mark agents for removal, without interupting the agents index
  // Going to store the index of all agents that are being removed from energy<0
  no_energy = new ArrayList();
  
  for (int i = agents.size()-1; i>=0; i--) {

    Agent a = agents.get(i);
    
    // attatching agents to bins "water_holes"
    // going to use later for predators
    if (a.x >= 0 && a.y >= 0 && a.x < width && a.y < height) {
      water_holes.put(map.grid.xy_to_index(a.x, a.y), i);
    }
    
    a.move(); // Move triggers reproduce and harvest
    if (a.energy<0) {
      //if (random(1) < .00005) { preds.add(new Pred(a.x, a.y, a.harvest_rate_a, a.harvest_rate_b, a.harvest_rate_c, a.harvest_rate_d, a.wind_max, a.rest_count_max, a.rest_count)); };
      no_energy.add(i);
      //println(a.age);
      //agents.remove(i);
      //a.display();
    }
    
    if (!hide_agents) { a.display(); }
  }
  
  
  // Predator control
  for (int i = preds.size()-1; i>=0; i--) {
    
    Pred p = preds.get(i);
    
    p.move();
    
    if (p.energy<0) {
      //println("A predator has died");
      preds.remove(i);
    }
    
    if (!hide_preds) { p.display(); }
  }
  
  
  // Cleaning up the fallen
  // Start by sorting the no_energy array
  Collections.sort(no_energy); // sorts in ascending order
  //println(no_energy);
  for (int i= agents.size()-1; i>=0; i--) {
    if (no_energy.size()>0) {
      if (i == no_energy.get(no_energy.size()-1)) {
        no_energy.remove(no_energy.size()-1);
        if (no_energy.size() > 0) {
          while(no_energy.get(no_energy.size()-1) == i) {
            no_energy.remove(no_energy.size()-1);
            if (no_energy.size() == 0) { break; }
          }
        }
        agents.remove(i);
      }
    }
  }
  
  if (!hide_window) { win.display(1); }
}

void keyPressed() {
  if (key == 'g') {
    hide_grid = !hide_grid;
  }
  if (key == 'a') {
    hide_agents = !hide_agents;
  }
  if (key == 'c') {
    hide_resources = !hide_resources;
  }
  if (key == 'w') {
    hide_window = !hide_window;
  }
  if (key == 'p') {
    hide_preds = !hide_preds;
  }
  if (key == ' ') {
    int rand_index = int(random(agents.size()));
    Agent a = agents.get(rand_index);
    preds.add(new Pred(a.x, a.y, a.harvest_rate_a, a.harvest_rate_b, a.harvest_rate_c, a.harvest_rate_d, a.wind_max, a.rest_count_max, a.rest_count)); }
}