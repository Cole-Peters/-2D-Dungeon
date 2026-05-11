/**
 *      Author: Kyle Bernet, Cole Peters
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-25
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: HealthPickup.pde
 * Description: A health pickup that heals the player a little
 */

class HealthPickup extends Interactable {

  public HealthPickup() {
  }

  public HealthPickup(JSONObject object) {
  }

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "HealthPickup");
    return object;
  }

  public void draw() {
    float sprSize = 28;
    imageMode(CENTER);
    noTint();
    if (orbSprite != null && orbSprite.width > 0) {
      image(orbSprite, 0, 0, sprSize, sprSize);
    } else {
      fill(50, 200, 80);
      stroke(20, 120, 40);
      strokeWeight(1);
      ellipse(0, 0, 18, 18);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(12);
      text("+", 0, 0);
      textAlign(LEFT, BASELINE);
    }
  }

  public boolean interact(Player player) {
    if (player == null) {
      return false;
    }
    // bump health a bit; updateHealth clamps to max
    player.updateHealth(18);
    return true;
  }
}
