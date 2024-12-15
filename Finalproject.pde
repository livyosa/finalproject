import java.util.ArrayList;

ArrayList<Particle> particles;

void setup() {
  size(800, 600);
  background(0);

  // Initialize particle list
  particles = new ArrayList<Particle>();
}

void draw() {
  background(0, 10); // Slight transparency to create trailing effect

  // Generate particles randomly across the canvas
  if (frameCount % 5 == 0) {
    particles.add(new Particle(random(width), random(height), false));
  }

  // Update and draw particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();

    // Remove dead particles, except for mouse-dragged particles
    if (p.isDead() && !p.persistent) {
      particles.remove(i);
    }
  }
}

void mouseDragged() {
  // Only add particles when left mouse button is pressed
  if (mouseButton == LEFT) {
    particles.add(new Particle(mouseX, mouseY, true));
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    // Trigger vacuum effect when right mouse button is pressed
    for (Particle p : particles) {
      float dx = mouseX - p.x;
      float dy = mouseY - p.y;
      float distance = dist(mouseX, mouseY, p.x, p.y);

      // Clamp distance to avoid division by zero
      float clampedDistance = max(distance, 10);

      // Stronger attraction for vacuum effect
      float attractionMultiplier = pow(1 / clampedDistance, 1.5);
      float attractionX = dx * attractionMultiplier * 10; // Increase strength
      float attractionY = dy * attractionMultiplier * 10;

      p.vx += attractionX;
      p.vy += attractionY;
    }
  }
}

class Particle {
  // Position
  float x, y;

  // Velocity
  float vx, vy;

  // Size
  float size;

  // Lifespan
  float lifespan;

  // Attraction strength
  float attractionStrength;

  // Persistent flag
  boolean persistent;

  // Constructor with optional persistence
  Particle(float startX, float startY, boolean isPersistent) {
    // Start at given position
    x = startX;
    y = startY;

    // Random velocity with less spread
    float angle = random(TWO_PI);
    float speed = random(1, 3);
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;

    // Random size
    size = random(5, 15);

    // Lifespan for non-persistent particles
    lifespan = isPersistent ? Float.MAX_VALUE : 255;

    // Set attraction strength
    attractionStrength = random(0.5, 2.0); // Higher strength for stronger pull

    // Set persistence
    persistent = isPersistent;
  }

  // Update particle
  void update() {
    // Calculate direction and distance to the mouse
    float dx = mouseX - x;
    float dy = mouseY - y;
    float distance = dist(mouseX, mouseY, x, y);

    // Clamp distance to avoid division by zero
    float clampedDistance = max(distance, 10);

    // Calculate attraction with inverse-square scaling
    float attractionMultiplier = pow(1 / clampedDistance, 2);
    float attractionX = dx * attractionMultiplier * attractionStrength;
    float attractionY = dy * attractionMultiplier * attractionStrength;

    // Add attraction to velocity
    vx += attractionX;
    vy += attractionY;

    // Dampen velocity
    vx *= 0.95;
    vy *= 0.95;

    // Cap velocity
    float maxSpeed = 10;
    float speed = dist(0, 0, vx, vy);
    if (speed > maxSpeed) {
      vx = (vx / speed) * maxSpeed;
      vy = (vy / speed) * maxSpeed;
    }

    // Update position
    x += vx;
    y += vy;

    // Reduce lifespan gradually for non-persistent particles
    if (!persistent) {
      lifespan -= 10;
    }
  }

  // Display particle
  void display() {
    // Ocean-inspired bioluminescent effect with blue and green hues
    float oceanBlue = random(0, 100);  // Shades of deep blue
    float oceanGreen = random(150, 255);  // Shades of teal/green
    fill(oceanBlue, oceanGreen, random(200, 255), lifespan); // Use lifespan for alpha
    noStroke();

    // Draw particle
    ellipse(x, y, size, size);
  }

  // Check if particle is dead
  boolean isDead() {
    return lifespan < 10 || 
           x < 0 || x > width || 
           y < 0 || y > height;
  }
}
