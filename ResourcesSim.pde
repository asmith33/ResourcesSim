import java.util.*;
import toxi.geom.*;

Map map;
Window win;
Resource ra, rb, rc, re, rf, rg, rh, ri, rj;
ArrayList<Agent> agents;
boolean hide_agents, hide_grid=true, hide_resources=true, hide_window=true;


void setup() {
  size(1000, 600, P2D);
  win = new Window();
  map = new Map(width, height, 5);
  //Resource(int type_, int radius_, int x_, int y_, int vx_, int vy_, float growth_rate_, float decay_rate_, int max_per_bin_) {
  ra = new Resource(0, 100, width/2, height/2, 0, 0, .0075, 0, 30); // red
  rb = new Resource(1, 100, 100, height - 100, 1, 0, .01, 0, 30); // green
  rc = new Resource(2, 300, width/2, height/2, 0, 0, .005, 0, 30); // blue
  re = new Resource(0, 100, 100, height/2, 1, -1, .0075, 0, 30); // red
  rf = new Resource(2, 80, 80, 80, 0, 0, .015, 0, 30); // blue
  rg = new Resource(2, 80, width-80, 80, 0, 0, .015, 0, 30); // blue
  rh = new Resource(1, 100, 625, 125, 0, 0, .01, 0, 30); // green
  ri = new Resource(0, 50, width-50, height-50, 0, 0, .0075, 0, 30); // red
  rj = new Resource(2, 50, width-150, height-53, 1, -3, .01, 0, 30); // blue
  
  agents = new ArrayList();
  for (int i=0; i<100; i++) {
    //Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
    agents.add(new Agent(width/2 + 5*i, height/2 - 2*i, .15, .05, .025, .00, 1, int(random(10)), int(millis())%10));
  }
  for (int i=0; i<150; i++) {
    agents.add(new Agent(width/2 + 5*(-i+20), height/2 - 2*(i+50), .15, .05, .025, .00, 1, int(random(10)), int(millis())%10));
  }
}

void draw() {
  background(55);
  surface.setTitle(round(frameRate) + " fps || agents " + agents.size());
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
  ra.replenish();
  rb.replenish();
  rc.replenish();
  re.replenish();
  rf.replenish();
  rg.replenish();
  rh.replenish();
  ri.replenish();
  rj.replenish();
  ra.display();
  rb.display();
  rc.display();
  re.display();
  rf.display();
  rg.display();
  rh.display();
  ri.display();
  rj.display();

  for (int i = agents.size()-1; i>=0; i--) {

    Agent a = agents.get(i);

    a.move(); // Move triggers reproduce and harvest
    if (a.energy<0) {
      //println(a.age);
      agents.remove(i);
      //a.display();
    }
    
    if (!hide_agents) { a.display(); }
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
}