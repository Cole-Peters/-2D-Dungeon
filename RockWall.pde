/**
 * Simple rock obstacle — blocks movement (not an Actor).
 */

class RockWall extends WorldObject {

  public RockWall() {
  }

  public RockWall(JSONObject object) {
    // no extra fields to load
  }

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "RockWall");
    return object;
  }

  public void draw() {
    float sprSize = 46;
    imageMode(CENTER);
    noTint();
    if (clashStoneSprite != null && clashStoneSprite.width > 0) {
      image(clashStoneSprite, 0, 0, sprSize, sprSize);
    } else {
      fill(110, 100, 90);
      stroke(60, 55, 50);
      strokeWeight(1);
      rectMode(CENTER);
      rect(0, 0, 26, 26);
      rectMode(CORNER);
    }
  }
}
