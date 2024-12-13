ArrayList<Particle> particles;

void setup() {
  size(800, 600);
  background(0);

  // Initialize particle list
  particles = new ArrayList<Particle>();
}

void draw() {
  background(0, 20); // Slight transparency to create trailing effect

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
  // Add new particles where the mouse is dragged
  particles.add(new Particle(mouseX, mouseY, false));
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
    attractionStrength = random(0.1, 0.5);

    // Set persistence
    persistent = isPersistent;
  }

  // Update particle
  void update() {
    // Calculate direction to the mouse position
    float angleToMouse = atan2(mouseY - y, mouseX - x);

    // Move particles towards the mouse
    float attractionX = cos(angleToMouse) * attractionStrength;
    float attractionY = sin(angleToMouse) * attractionStrength;

    vx += attractionX;
    vy += attractionY;

    // Move the particle
    x += vx;
    y += vy;

    // Reduce lifespan gradually for non-persistent particles
    if (!persistent) {
      lifespan -= -5; // Decrease more gradually for smoother fade
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
    return lifespan < 0 || 
           x < 0 || x > width || 
           y < 0 || y > height;
  }
}
