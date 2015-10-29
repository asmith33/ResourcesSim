import java.util.*;
import toxi.geom.*;

Map map;
Window win;
Resource ra;

void setup() {
  size(1000, 1000, P2D);
  win = new Window();
  map = new Map(width, height, 10);
  ra = new Resource(0, 50, 50, 50, 0, 0, .15, 50);
}

void draw() {
  background(85);
  surface.setTitle(round(frameRate) + "fps");
  map.grid.display();
  ra.replenish();
  ra.display();
  win.display(1);
}