/**
 *      Author: Prof. Morales, Kyle Bernet, Cole Peters
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Project4.pde
 * Description: A dungeon crawler game
 */

import processing.sound.*;

Scene scene;
String fileName;
SoundFile bgMusic;

// Sprites from the sketch data folder (data/knight.png, data/goblin.png)
PImage knightSprite;
PImage goblinSprite;
// Optional: repeating floor texture per tile (data/floor.png)
PImage floorSprite;
// Obstacle sprite for RockWall (data/clashstone.png)
PImage clashStoneSprite;

/**
 *      Method: setup()
 *  Parameters: void
 *      Return: void
 * Description: Constructs a scene from JSON
 *              save data or in a random state
 */

void setup() {
  fullScreen(P2D);
  pixelDensity(1);
  knightSprite = loadImage("knight.png");
  goblinSprite = loadImage("goblin.png");
  floorSprite = loadImage("floor.png");
  clashStoneSprite = loadImage("clashstone.png");
  bgMusic = new SoundFile(this, "HarvestDawn.mp3");
  bgMusic.loop();
  fileName = sketchPath("data/save.json");
  File file = new File(fileName);

  if (file.exists()) {
    JSONObject data = loadJSONObject(fileName);
    scene = new Scene(data);
  } else {
    scene = new Scene();
    JSONObject data = scene.serialize();
    file.getParentFile().mkdirs();
    saveJSONObject(data, fileName);
  }
}

/**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Draws the scene and all objects
 *              within it, additionally performing
 *              logic for the main game loop
 */

void draw() {
  background(0);

  if (scene.tryTurn()) {
    // Save the state of the scene
    saveJSONObject(scene.serialize(), fileName);
  }

  scene.draw();
}

/**
 *      Method: keyPressed()
 *  Parameters: void
 *      Return: void
 * Description: Passes key press events to the scene
 */

void keyPressed() {
  scene.keyPressed();
}

/**
 *      Method: keyReleased()
 *  Parameters: void
 *      Return: void
 * Description: Passes key release events to the scene
 */

void keyReleased() {
  scene.keyReleased();
}
