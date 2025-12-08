// MLX90641_Heatmap.pde
// Author: Perplexity AI, with assistance from D. Dubins
// Date: 05-Dec-25
// Simple 16x12 heat map for MLX90641 serial output
// Expects lines: Tth, p0, p1, ... p191 (comma-separated)
// Match port name + baud (115200) to your Arduino

import processing.serial.*;

Serial myPort;
float[] pixels = new float[192];
boolean haveFrame = false;

// grid / window settings
int cols = 16;
int rows = 12;
int cellSize = 60;         // pixel size of each cell
int margin = 20;           // outer margin

// value range for color mapping (adjust to your environment)
float minTemp = 20;        // cold color at/below this
float maxTemp = 35;        // hot color at/above this

void settings() {
  size(cols * cellSize + margin * 2, rows * cellSize + margin * 2);
}

void setup() {
  // List available ports in the console
  println(Serial.list());

  // Pick the right index from the printed list
  String portName = Serial.list()[0];   // change 0 -> 1/2/... as needed
  myPort = new Serial(this, portName, 115200);

  // Read one line at a time
  myPort.bufferUntil('\n');

  textAlign(CENTER, CENTER);
  textSize(14);
}

void draw() {
  background(0);

  if (!haveFrame) {
    // Show simple message until first valid frame
    fill(255);
    text("Waiting for data...", width/2, height/2);
    return;
  }

  // Draw 8x8 heatmap
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      int idx = y * cols + x;    // linear index 0..191
      float t = pixels[idx];

      // Clamp to [minTemp, maxTemp]
      float tt = constrain(t, minTemp, maxTemp);
      float frac = map(tt, minTemp, maxTemp, 0, 1);

      // Simple blue->red gradient
      // cold: blue (0,0,255), hot: red (255,0,0)
      float r = lerp(0, 255, frac);
      float g = 0;
      float b = lerp(255, 0, frac);

      int x0 = margin + x * cellSize;
      int y0 = margin + y * cellSize;

      noStroke();
      fill(r, g, b);
      rect(x0, y0, cellSize, cellSize);

      // Draw temperature text in white or black depending on background
      float brightness = (r + g + b) / 3.0;
      if (brightness < 128) {
        fill(255);
      } else {
        fill(0);
      }

      // Show 1 decimal place; adjust as desired
      String label = nf(t, 0, 1);
      text(label, x0 + cellSize / 2.0, y0 + cellSize / 2.0);
    }
  }
}

// Called automatically when a '\n' is received
void serialEvent(Serial s) {
  String line = trim(s.readStringUntil('\n'));
  if (line == null || line.length() == 0) {
    return;
  }

  // Split on commas
  String[] parts = split(line, ',');

  // Expect 1 + 192 = 193 values (thermistor + 192 pixels)
  if (parts.length < 193) {
    // Not a full frame; ignore
    println("Short line, len = " + parts.length + ": " + line);
    return;
  }

  // Parse pixel temperatures (skip index 0 which is thermistor)
  for (int i = 0; i < 192; i++) {
    pixels[i] = parseFloat(parts[i + 1]);
  }

  haveFrame = true;
}
