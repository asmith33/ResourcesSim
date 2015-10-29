import java.util.*;
import toxi.geom.*;

Map map;
Window win;
Resource ra, rb, rc, re;
ArrayList<Agent> agents;
boolean hide_agents, hide_grid, hide_resources;


void setup() {
  size(1000, 1000, P2D);
  win = new Window();
  map = new Map(width, height, 5);
  //Resource(int type_, int radius_, int x_, int y_, int vx_, int vy_, float growth_rate_, float decay_rate_, int max_per_bin_) {
  ra = new Resource(0, 100, 150, 150, 0, 0, .015, 0, 75);
  rb = new Resource(1, 150, 400, 200, 0, 1, .01, 0, 50);
  rc = new Resource(2, 350, 400, 500, 0, 0, .005, 0, 50);
  re = new Resource(0, 100, 750, 750, 0, 1, .015, 0, 100);
  
  agents = new ArrayList();
  for (int i=0; i<100; i++) {
    //Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
    agents.add(new Agent(width/2 + 5*(i-100), height/2 - 2*(i+2), .15, .05, .025, .00, 1, int(random(10)), int(millis())%10));
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
  ra.replenish();
  rb.replenish();
  rc.replenish();
  re.replenish();
  ra.display();
  rb.display();
  rc.display();
  re.display();


  for (int i = agents.size()-1; i>=0; i--) {

    Agent a = agents.get(i);

    a.move(); // Move triggers reproduce and harvest
    if (a.energy<0) {
      agents.remove(i);
      //a.display();
    }
    
    if (!hide_agents) { a.display(); }
  }
  win.display(1);
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
}