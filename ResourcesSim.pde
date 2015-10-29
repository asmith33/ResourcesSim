import java.util.*;
import toxi.geom.*;

Map map;
Window win;
Resource ra;
ArrayList<Agent> agents;

void setup() {
  size(1000, 1000, P2D);
  win = new Window();
  map = new Map(width, height, 10);
  ra = new Resource(0, 75, 150, 75, 1, 1, .025, 0, 50);
  agents = new ArrayList();
  for (int i=0; i<100; i++) {
    agents.add(new Agent(width/2 + 5*(i-50), height/2 - 2*(i+2), .05, 1/35, 1/50, 1/35, 1));
  }
  for (int i=0; i<150; i++) {
    agents.add(new Agent(width/2 + 5*(-i+50), height/2 - 2*(i+50), .2, 1/35, 1/50, 1/35, 1));
  }
}

void draw() {
  background(55);
  surface.setTitle(round(frameRate) + "fps");
  map.grid.display();
  ra.move();
  ra.replenish();
  ra.display();


  for (int i = agents.size()-1; i>=0; i--) {

    Agent a = agents.get(i);

    a.harvest(0);
    //if (rb.isWithin(a.x,a.y)) { a.harvest(1); }
    //if (rc.isWithin(a.x,a.y)) { a.harvest(2); }
    //if (rd.isWithin(a.x,a.y)) { a.harvest(3); }

    a.move();
    if (a.energy<0) {
      agents.remove(i);
    } else {
      a.display();
    }
  }
  win.display(1);
}