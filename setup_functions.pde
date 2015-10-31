void make_resources() {
  //Resource(int type_, int radius_, int x_, int y_, int vx_, int vy_, float growth_rate_, float decay_rate_, int max_per_bin_) {
  ra = new Resource(0, 100, width/2, height/2, 0, 0, .008, 0, 15); // red (center)
  rb = new Resource(1, 100, 100, height - 100, 1, 0, .015, 0, 15); // green (bottom mover)
  rc = new Resource(2, 300, width/2, height/2, 0, 0, .007, 0, 15); // blue (center)
  re = new Resource(0, 100, 100, height/2, 1, -1, .012, 0, 15); // red (top left mover)
  rf = new Resource(2, 80, 80, 80, 0, 0, .007, 0, 15); // blue (top left)
  rg = new Resource(2, 80, width-80, 120, 0, 0, .007, 0, 15); // blue (top right)
  rh = new Resource(1, 100, 625, 125, 0, 0, .008, 0, 15); // green (right center)
  ri = new Resource(0, 50, width-50, height-50, 0, 0, .007, 0, 15); // red (bottom left)
  rj = new Resource(2, 50, width-150, height-53, 1, -3, .012, 0, 15); // blue (bottom mover)
  rk = new Resource(1, 100, width-100, height-100, -1, 0, .015, 0, 15); // green (bottom mover)
  rl = new Resource(1, 100, 150, 300, 0, 0, .008, 0, 15); // green (left mid)
}