/**
 * Basic enemy: attacks if it can, otherwise picks a random valid move.
 */

class Goblin extends Actor {

  public Goblin(Direction facing) {
    super(28, 6, facing);
  }

  public Goblin(JSONObject object) {
    super(object);
  }

  public JSONObject serialize() {
    JSONObject object = super.serialize();
    object.setString("className", "Goblin");
    return object;
  }

  public void draw() {
    super.draw();
    float sprSize = 28;
    imageMode(CENTER);
    noTint();
    if (goblinSprite != null && goblinSprite.width > 0) {
      pushMatrix();
      if (facing == Direction.WEST) {
        scale(-1, 1);
      }
      image(goblinSprite, 0, 2, sprSize, sprSize);
      popMatrix();
    } else {
      fill(160, 60, 60);
      stroke(40, 20, 20);
      strokeWeight(1);
      rectMode(CENTER);
      rect(0, 2, 20, 18);
      rectMode(CORNER);
    }
    stroke(255, 220, 100);
    strokeWeight(2);
    line(0, 2, facing.x * 12, facing.y * 12 + 2);
    strokeWeight(1);
  }

  public Action getAction() {
    Action[] all = Action.values();
    int nAttack = 0;
    for (Action a : all) {
      if (getActionValidity(a) && a.isAttack) {
        nAttack++;
      }
    }
    if (nAttack > 0) {
      int pick = int(random(nAttack));
      for (Action a : all) {
        if (getActionValidity(a) && a.isAttack) {
          if (pick == 0) {
            return a;
          }
          pick--;
        }
      }
    }
    int nMove = 0;
    for (Action a : all) {
      if (getActionValidity(a) && !a.isAttack) {
        nMove++;
      }
    }
    if (nMove > 0) {
      int pick = int(random(nMove));
      for (Action a : all) {
        if (getActionValidity(a) && !a.isAttack) {
          if (pick == 0) {
            return a;
          }
          pick--;
        }
      }
    }
    return null;
  }
}
