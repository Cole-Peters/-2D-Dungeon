/**
 * Walk on it to heal the player a little (Interactable).
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

  public boolean interact(Player player) {
    if (player == null) {
      return false;
    }
    // bump health a bit; updateHealth clamps to max
    player.updateHealth(18);
    return true;
  }
}
