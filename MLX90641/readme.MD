# MLX90641 IR Array - Thermal Sensor Project

This project explores the **MLX90641**, a compact **16×12 infrared (IR) thermal camera** designed for measuring temperature variations across surfaces, such as an incubator plate.

A student of mine selected this sensor for a proposal, and I agreed before fully digging into its requirements. As it turns out… this fascinating little device demands *quite a bit* from the microcontroller driving it.

---

## About the MLX90641

- **Resolution:** 16 × 12 pixels  
- **Calibration:** Fully factory-calibrated  
- **Accuracy:** ±1 °C  
- **Complexity:** Higher than expected!  

Compared to the AMG8833 grid-eye sensor, the MLX90641 offers better accuracy but also requires significantly more processing power and careful handling of calibration and timing. Most existing libraries target **Mbed OS / Mbed CE** microcontrollers and don’t play nicely with common hobbyist boards like the **Arduino Mega 2560** or even the **ESP32** without substantial modification.

> **Important:**  
> This sensor is *not* well-suited to the classic Arduino Uno R3.  
> It needs a **fast microcontroller** with enough RAM and I²C throughput.

---

## Project Goal

With help from AI tools and the official Melexis datasheet, I put together a **standalone Arduino sketch** capable of reading data from the MLX90641. It works—but the process is intricate due to the sensor’s calibration math, frame timing, and EEPROM parameter handling.

You've been warned: **this sensor is complicated**.

If you want an easier alternative with more library support, consider the **MLX90640**, the 32×16-pixel version.

---

## Files in this Directory

**MLX90641.ino** is a library-free standalone file for the MLX90641, written for the ESP32.

**MLX90641_processing.ino** is a stripped-down version of this file, written to generate a heatmap in Processing (one line on the Serial monitor for all pixel data).

**MLX90641_Heatmap.pde** is a program to receive the data from MLX90641_processing.ino and generate the heatmap.

**MLX90641_NeoPixel.pde** is a program to receive the data from MLX90641_processing.ino and print it to a NeoPixel 16x16 led screen.

---

## 🚧 Status

- [x] Basic communication working  
- [x] Sensor reading and conversion implemented  
- [ ] Data visualization tools  
- [ ] Cleanup and documentation  

---
