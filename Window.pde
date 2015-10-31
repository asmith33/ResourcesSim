class Window {
  /*
   * Going to use this class for all data output
   */
  int w; // window width
  int h; // window height
  int tl_x; // top left x
  int tl_y; // top left y
  int state; // the state variable will be used to determine the data displayed
   
  Window () {
    w = 300;
    h = 255;
    tl_x = 10;
    tl_y = 10;
  }
       
  void display (int s) {
    state = s;
       
    switch(state) {
      case 0:
        draw_window();
        fill(205);
        String line0, line1, line2, line3, line4, line5;
        line0 = "w : toggle window";
        line1 = "a : toggle agents";
        line2 = "r : toggle regions";
        line3 = "g : toggle grid";
        line4 = "p : toggle predators";
        line5 = "'space' : spawn predators";
        text(line0, tl_x+5, tl_y + 20);
        text(line1, tl_x+5, tl_y + 42);
        text(line2, tl_x+5, tl_y + 64); 
        text(line3, tl_x+5, tl_y + 86); 
        text(line4, tl_x+5, tl_y + 108); 
        text(line5, tl_x+5, tl_y + 130); 
        break;
      case 1:
        // this used to display bin values. Not using it currently.
        /*
        draw_window();
        fill(205);
        String line0, line1, line2, line3, line4;
        line0 = "Bin # ";
        line1 = "Energy_A = ";
        line2 = "Energy_B = ";
        line3 = "Energy_C = ";
        line4 = "Energy_D = ";
        if (mouseX > 0 && mouseX < width && mouseY  > 0 && mouseY < height) {
        Bin b = map.grid.get_bin(mouseX, mouseY, 7);
          float ea = b.energies.get(0);
          float eb = b.energies.get(1);
          float ec = b.energies.get(2);
          float ed = b.energies.get(3);
          text(line0, tl_x+5, tl_y + 20);
          text(b.index, tl_x + 85, tl_y + 20);
          text(line1, tl_x+5, tl_y + 42);
          text(ea, tl_x + 85, tl_y + 42);
          text(line2, tl_x+5, tl_y + 64); 
          text(eb, tl_x + 85, tl_y + 64);
          text(line3, tl_x+5, tl_y + 86); 
          text(ec, tl_x + 85, tl_y + 86);
          text(line4, tl_x+5, tl_y + 108); 
          text(ed, tl_x + 85, tl_y + 108); 
        }
        */
        break;
    }
  }
     
  
  void draw_window() {
    stroke(39,82,135);
    strokeWeight(2);
    fill(55);
    rect(tl_x, tl_y, w, h);
  }
  
}