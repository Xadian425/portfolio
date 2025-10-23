//Xadian Butcher | 10/18/25 | SpaceGame
SpaceShip s1;
Rock r1;
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
Timer rockTimer, puTimer;
int score, rocksPassed;

void setup() {
  size(500, 500);
  s1 = new SpaceShip();
  r1 = new Rock();
  puTimer = new Timer(5000);
  puTimer.start();
  rockTimer = new Timer(1000);
  rockTimer.start();
  score = 0;
  rocksPassed = 0;
}

void draw() {
  background(10);

  // Distributes a powerup on a Timer
  if (puTimer.isFinished()) {
    powups.add(new PowerUp());
    puTimer.start();

    // Display and moves all powerups
    for (int i = 0; i < powups.size(); i++) {
      PowerUp pu = powups.get(i);
      pu.move();
      pu.display();

      // collison detection between rock and ship
      if (pu.intersect(s1)) {
        // Remove PowerUp
        powups.remove(pu);
        //Based on type benefit player
        if (pu.type == 'H') {
          s1.health+=100;
        } else if (pu.type == 'T') {
          s1.turretCount+=1;
          if (s1.turretCount>5) {
            s1.turretCount = 5;
          }
        } else if (pu.type == 'A') {
          s1.laserCount+=1000;
        }
      }
      if (pu.reachedBottom()==true) {
        powups.remove(pu);
        // infulence score

        // lower health of ship
      }
      println(powups.size());
    }

    //adding stars
    stars.add(new Star());

    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      if (star.reachedBottom()) {
        stars.remove(star);
      }
    }

    // Distributing Rocks on Timer
    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }
    // Display of Rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      // collison detection between rock and ship
      if (s1.intersect(rock)) {
        rocks.remove(rock);
        score = score + rock.diam;
        s1.health -= rock.diam;
      }
      rock.display();
      rock.move();
      if (rock.reachedBottom()==true) {
        rocks.remove(rock);
        // infulence score

        // lower health of ship
        rocksPassed++;
      }
      println(rocks.size());
    }


    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      for (int j = 0; j<rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (laser.intersect(r)) {
          // Reduce hit points on rock and removes rock
          r.diam = r.diam - 10;
          if (r.diam<5) {
            rocks.remove(r);
          }
          // Remove the laser
          lasers.remove(laser);
          // Do something
          score = score +10;
          // Provide amimated gif and explosion sound
        }
      }
      laser.display();
      laser.move();
      if (laser.reachedTop()) {
        lasers.remove(laser);
      }
    }

    s1.display();
    s1.move(mouseX, mouseY);
    r1.display();
    r1.move();
    r1.reachedBottom();
    infoPanel();
  }
}
void mousePressed() {
  if (s1.fire()) {
    lasers.add(new Laser(s1.x, s1.y));
    s1.laserCount--;
  }
}


void infoPanel() {
  rectMode(CENTER);
  fill(127, 127);
  rect(width/2, 25, width, 50);
  fill(220);
  textSize(25);
  text("Score:" + score, 20, 40);
  text("Passed Rocks: "+rocksPassed, width - 180, 40);
  text("Health: "+ s1.health, 350, height-20);
  text("Ammo: " + s1.laserCount, 200, height -20);
  text("Turrets: " + s1.turretCount, width-180, 475);
  fill(255);
  rect(50, height-100, 100, 10);
  fill(255, 0, 0);
  rect(50, height-100, s1.health, 10);
}
