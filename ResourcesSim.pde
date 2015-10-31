// asmith33@github.com

import java.util.*;
import com.google.common.collect.*;
import controlP5.*;


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
Resource ra, rb, rc, re, rf, rg, rh, ri, rj, rk, rl;

// Initializing controller
ControlP5 MyController;
controlP5.Slider spawn_rate_slider_obj;
controlP5.Slider mutation_rate_slider_obj;
controlP5.Slider predator_move_cost_obj;
controlP5.Slider predator_no_food_cost_obj;
controlP5.Slider predator_spawn_rate_obj;

// agents collect energy from bins
ArrayList<Agent> agents;
// predators collect energy from agents
ArrayList<Pred> preds;
// keyboard input signals
boolean hide_agents, hide_grid=true, hide_resources=true, hide_window=true, hide_preds;

// map -> grid -> bins
// key : bin index
// value : collection of integers
// those values are the index of each agent at that bin
Multimap<Integer, Integer> water_holes;

// when agents run out of energy, i cant remove them from array
// until after the predators have taken their turn. This array
// stores the index of the agents who have run out of energy and
// need to be removed later
ArrayList<Integer> no_energy;


// Global variable that are controlled by sliders/buttons
float spawn_rate_slider_val = .01;
float mutation_rate_slider_val = .1;
int predator_move_cost_val = 5;
int predator_no_food_cost_val = 3;
float predator_spawn_rate_val = .1;

void setup() {
  size(1000, 600, P2D);
  win = new Window();
  map = new Map(width, height, 10);
  
  // in setup_functions tab
  // this creates the regions that supply energy to the grid
  make_resources();
  
  // Initialize agents array, then spawn agents.
  // The inner loop can be used to increase agent density
  agents = new ArrayList();
  for (int i=0; i<width/2; i++) {
    for (int j=0; j<1; j++) {
      //Agent(int x_, int y_, float ha, float hb, float hc, float hd, int wm, int rest_count_max_, int rest_count_) {
      agents.add(new Agent(i+width/4, height/2, .175, .1625, .1625, .00, 1, int(random(8)), int(millis())%5, spawn_rate_slider_val, mutation_rate_slider_val));
    }
  }
  
  // Initialize predator array
  // Predators are created via user input
  preds = new ArrayList();
  
  // Initialize the controller for buttons/switches
  // Then make the sliders
  // http://wiki.bk.tudelft.nl/toi-pedia/Processing_Buttons_and_Sliders
  MyController = new ControlP5(this);
  //                                            name   ,                 lower, upper, start, tl_x, tl_y, width, height
  spawn_rate_slider_obj = MyController.addSlider("spawn_rate_slider_val", 0, .1, spawn_rate_slider_val, 20, 160, 100, 10); 
  mutation_rate_slider_obj = MyController.addSlider("mutation_rate_slider_val", 0, 1, mutation_rate_slider_val, 20, 180, 100, 10); 
  predator_move_cost_obj = MyController.addSlider("predator_move_cost_val", 0, 50, predator_move_cost_val, 20, 200, 100, 10); 
  predator_no_food_cost_obj = MyController.addSlider("predator_no_food_cost_val", -1, 50, predator_no_food_cost_val, 20, 220, 100, 10);
  predator_spawn_rate_obj = MyController.addSlider("predator_spawn_rate", 0, .2, predator_spawn_rate_val, 20, 240, 100, 10); 
}

void draw() {
  background(55);
  
  // this line outputs to the top of the window. i have to switch between
  // 'surface' and 'frame', depending on which computer im using
  surface.setTitle("press w || " + round(frameRate) + " fps || agents " + agents.size() + " || predators " + preds.size() + " || total " + (agents.size()+preds.size()));
  
  // displaying the grid gives a view of the energy levels in each bin
  // The amount of energy in each bin is mapped to an RGB value
  if (!hide_grid) { map.grid.display(); }
  
  // See draw_functions tab
  move_resources();
  replenish_resources();
  display_resources();
  
  
  // This Multimap is going to map bin index to a collection of agent indicies.
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
    
    // Move triggers reproduce and harvest
    a.move(); 
    
    // Don't remove the agent, add to list and remove later.
    // I can't change the indicies until predators have had their turn
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
      
      preds.remove(i);
    }
    
    if (!hide_preds) { p.display(); }
  }
  
  
  // Cleaning up the fallen
  // Start by sorting the no_energy array
  Collections.sort(no_energy); // sorts in ascending order
  //println(no_energy);
  // it works, i think.
  // dont really want to untangle this knot right now
  // agents seem to be getting removed correctly
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
  
  // This toggle the display window
  if (!hide_window) {
    win.display(0);
    spawn_rate_slider_obj.show();
    mutation_rate_slider_obj.show();
    predator_move_cost_obj.show();
    predator_no_food_cost_obj.show();
    predator_spawn_rate_obj.show();
  } else {
    spawn_rate_slider_obj.hide();
    mutation_rate_slider_obj.hide();
    predator_move_cost_obj.hide();
    predator_no_food_cost_obj.hide();
    predator_spawn_rate_obj.hide();
  }
  
}

void keyPressed() {
  if (key == 'g') {
    hide_grid = !hide_grid;
  }
  if (key == 'a') {
    hide_agents = !hide_agents;
  }
  if (key == 'r') {
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
    preds.add(new Pred(a.x, a.y, a.harvest_rate_a, a.harvest_rate_b, a.harvest_rate_c, a.harvest_rate_d, a.wind_max, a.rest_count_max, a.rest_count, predator_move_cost_val, predator_spawn_rate_val)); }
}