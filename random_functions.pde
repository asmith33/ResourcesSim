int rand_three() {
  /* 
   * This function will return a value of 1, 2, or 3, with a ~33% chance for each.
   * OUTPUTS: (int) 1, 2, or 3
   */
  float rnd = random(1);
  int x;
  
  if (rnd > .666666666666666) {
    x = 3;
  } else if (rnd > .333333333333333) {
    x = 2;
  } else {
    x = 1;
  }
  return x;
}

int rand_four() {
  float rnd = random(1);
  int x;
  
  if (rnd > .75) {
    x = 4;
  } else if (rnd > .5) {
    x = 3;
  } else if (rnd > .25) {
    x = 2;
  } else {
    x = 1;
  }
  return x;
}

boolean coin_flip() {
  float rnd = random(1);
  if (rnd >= .5) {
    return true;
  } else {
    return false;
  }
}