/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Scene.pde
 * Description: The game scene that handles each room
 *              and all objects within those rooms,
 *              including the player and enemies
 */

import java.util.LinkedList;

class Scene {
  private int roomWidth;
  private int roomHeight;
  private WorldObject[][] room;
  private Direction entry;
  private Player player;
  private LinkedList<Actor> enemies;
  private HashMap<WorldObject, Position> positions;
  private HashMap<Direction, Position> doors;

  /**
   * Constructor: public Scene()
   *  Parameters: void
   * Description: New game — random room and a new player
   */

  public Scene() {
    this.enemies = new LinkedList<Actor>();
    this.positions = new HashMap<WorldObject, Position>();
    this.doors = new HashMap<Direction, Position>();
    Direction start = Direction.values()[int(random(Direction.values().length))];
    this.player = new Player(start);
    this.reset(start);
  }

  /**
   * Constructor: public Scene()
   *  Parameters: JSONObject data - Saved game
   * Description: Loads a room from JSON
   */

  public Scene(JSONObject data) {
    this.enemies = new LinkedList<Actor>();
    this.positions = new HashMap<WorldObject, Position>();
    this.doors = new HashMap<Direction, Position>();
    this.loadFromJson(data);
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - whole room for save file
   * Description: Saves room size, doors, entry, and every tile object
   */

  public JSONObject serialize() {
    JSONObject data = new JSONObject();
    data.setInt("roomWidth", this.roomWidth);
    data.setInt("roomHeight", this.roomHeight);
    data.setString("entry", this.entry.name());
    JSONObject doorsJson = new JSONObject();
    for (Direction dir : Direction.values()) {
      Position p = this.doors.get(dir);
      if (p != null) {
        JSONObject pj = new JSONObject();
        pj.setInt("x", p.getX());
        pj.setInt("y", p.getY());
        doorsJson.setJSONObject(dir.name(), pj);
      }
    }
    data.setJSONObject("doors", doorsJson);
    JSONArray cells = new JSONArray();
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        if (this.room[x][y] != null) {
          JSONObject cell = new JSONObject();
          cell.setInt("x", x);
          cell.setInt("y", y);
          cell.setJSONObject("obj", this.room[x][y].serialize());
          cells.append(cell);
        }
      }
    }
    data.setJSONArray("cells", cells);
    return data;
  }

  private void loadFromJson(JSONObject data) {
    this.roomWidth = data.getInt("roomWidth");
    this.roomHeight = data.getInt("roomHeight");
    this.entry = Direction.valueOf(data.getString("entry"));
    this.room = new WorldObject[this.roomWidth][this.roomHeight];
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        this.room[x][y] = null;
      }
    }
    JSONObject doorsJson = data.getJSONObject("doors");
    for (Direction dir : Direction.values()) {
      if (doorsJson.hasKey(dir.name())) {
        JSONObject pj = doorsJson.getJSONObject(dir.name());
        this.doors.put(dir, new Position(pj.getInt("x"), pj.getInt("y"), this));
      }
    }
    JSONArray cells = data.getJSONArray("cells");
    for (int i = 0; i < cells.size(); i++) {
      JSONObject cell = cells.getJSONObject(i);
      int cx = cell.getInt("x");
      int cy = cell.getInt("y");
      JSONObject objJson = cell.getJSONObject("obj");
      this.room[cx][cy] = this.worldObjectFromJson(objJson);
    }
    this.player = null;
    this.enemies.clear();
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        WorldObject w = this.room[x][y];
        if (w instanceof Player) {
          this.player = (Player) w;
        } else if (w instanceof Actor) {
          this.enemies.add((Actor) w);
        }
      }
    }
    if (this.player == null) {
      this.player = new Player(this.entry);
    }
    this.clearRocksFromDoorTiles();
    this.rebuildPositions();
    this.updateActions(this.player);
  }

  private WorldObject worldObjectFromJson(JSONObject obj) {
    String name = obj.getString("className");
    if (name.equals("Player")) {
      return new Player(obj);
    }
    if (name.equals("Goblin")) {
      return new Goblin(obj);
    }
    if (name.equals("RockWall")) {
      return new RockWall(obj);
    }
    if (name.equals("HealthPickup")) {
      return new HealthPickup(obj);
    }
    return null;
  }

  private void rebuildPositions() {
    this.positions.clear();
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        WorldObject w = this.room[x][y];
        if (w instanceof Actor) {
          this.positions.put(w, new Position(x, y, this));
        }
      }
    }
  }

  // true if (x,y) is already used as a door tile
  private boolean cellHasDoor(int x, int y) {
    for (Position p : this.doors.values()) {
      if (p != null && p.getX() == x && p.getY() == y) {
        return true;
      }
    }
    return false;
  }

  // Inner rocks must not sit beside a door or you cannot reach the exit tile.
  private boolean isAdjacentToDoor(int x, int y) {
    for (Position p : this.doors.values()) {
      if (p == null) {
        continue;
      }
      int dx = abs(x - p.getX());
      int dy = abs(y - p.getY());
      if ((dx == 1 && dy == 0) || (dx == 0 && dy == 1)) {
        return true;
      }
    }
    return false;
  }

  // Door tiles must stay walkable — never leave a rock on an exit square.
  private void clearRocksFromDoorTiles() {
    for (Position p : this.doors.values()) {
      if (p == null) {
        continue;
      }
      int x = p.getX();
      int y = p.getY();
      if (x >= 0 && x < this.roomWidth && y >= 0 && y < this.roomHeight) {
        if (this.room[x][y] instanceof RockWall) {
          this.room[x][y] = null;
        }
      }
    }
  }

  /**
   *      Method: private reset()
   *  Parameters: Direction entry - The direction from which
   *                                the player entered the room
   *      Return: void
   * Description: Resets the room to a random state
   */

  private void reset(Direction entry) {
    if (entry == null) {
      return;
    }

    this.entry = entry;
    this.enemies.clear();
    this.positions.clear();
    this.doors.clear();

    this.roomWidth = int(random(10, 16));
    this.roomHeight = int(random(8, 13));
    this.room = new WorldObject[this.roomWidth][this.roomHeight];
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        this.room[x][y] = null;
      }
    }

    // door you came in through (so you can walk back the same way)
    Direction back = entry.inverse();
    int px = 1;
    int py = 1;
    if (back == Direction.NORTH) {
      px = int(random(1, this.roomWidth - 1));
      py = 0;
    } else if (back == Direction.SOUTH) {
      px = int(random(1, this.roomWidth - 1));
      py = this.roomHeight - 1;
    } else if (back == Direction.WEST) {
      px = 0;
      py = int(random(1, this.roomHeight - 1));
    } else if (back == Direction.EAST) {
      px = this.roomWidth - 1;
      py = int(random(1, this.roomHeight - 1));
    }
    this.doors.put(back, new Position(px, py, this));

    // maybe add another door or two (skip if same corner cell)
    for (Direction d : Direction.values()) {
      if (this.doors.containsKey(d)) {
        continue;
      }
      if (random(1) < 0.4) {
        int dx = 0;
        int dy = 0;
        if (d == Direction.NORTH) {
          dx = int(random(1, this.roomWidth - 1));
          dy = 0;
        } else if (d == Direction.SOUTH) {
          dx = int(random(1, this.roomWidth - 1));
          dy = this.roomHeight - 1;
        } else if (d == Direction.WEST) {
          dx = 0;
          dy = int(random(1, this.roomHeight - 1));
        } else if (d == Direction.EAST) {
          dx = this.roomWidth - 1;
          dy = int(random(1, this.roomHeight - 1));
        }
        if (!this.cellHasDoor(dx, dy)) {
          this.doors.put(d, new Position(dx, dy, this));
        }
      }
    }

    // border rocks, but not on door tiles
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        boolean border = x == 0 || x == this.roomWidth - 1 || y == 0 || y == this.roomHeight - 1;
        if (border && !this.cellHasDoor(x, y)) {
          this.room[x][y] = new RockWall();
        }
      }
    }

    // player stands on the entrance door, still same player object
    this.room[px][py] = this.player;
    this.player.facing = entry;

    // inner rocks / pickups / goblins
    for (int x = 1; x < this.roomWidth - 1; x++) {
      for (int y = 1; y < this.roomHeight - 1; y++) {
        if (this.room[x][y] != null) {
          continue;
        }
        if (random(1) < 0.12 && !this.isAdjacentToDoor(x, y)) {
          this.room[x][y] = new RockWall();
        }
      }
    }

    // Keep spawn playable: clear a small path in front of the player.
    int fx = px + entry.x;
    int fy = py + entry.y;
    if (fx > 0 && fx < this.roomWidth - 1 && fy > 0 && fy < this.roomHeight - 1) {
      this.room[fx][fy] = null;
      // Clear side tiles next to that first step so the player cannot get boxed in.
      if (entry == Direction.NORTH || entry == Direction.SOUTH) {
        if (fx - 1 > 0) {
          this.room[fx - 1][fy] = null;
        }
        if (fx + 1 < this.roomWidth - 1) {
          this.room[fx + 1][fy] = null;
        }
      } else {
        if (fy - 1 > 0) {
          this.room[fx][fy - 1] = null;
        }
        if (fy + 1 < this.roomHeight - 1) {
          this.room[fx][fy + 1] = null;
        }
      }
    }

    // one heal pickup on a free inner tile
    int tries = 0;
    while (tries < 200) {
      tries++;
      int hx = int(random(1, this.roomWidth - 1));
      int hy = int(random(1, this.roomHeight - 1));
      if (this.room[hx][hy] == null) {
        this.room[hx][hy] = new HealthPickup();
        break;
      }
    }

    int numGoblins = int(random(1, 4));
    int placed = 0;
    int guard = 0;
    while (placed < numGoblins && guard < 3000) {
      guard++;
      int gx = int(random(1, this.roomWidth - 1));
      int gy = int(random(1, this.roomHeight - 1));
      if (this.room[gx][gy] != null) {
        continue;
      }
      // do not spawn on top of the player
      if (gx == px && gy == py) {
        continue;
      }
      // keep enemies away from the spawn tile and first step to prevent instant lock
      if (abs(gx - px) <= 1 && abs(gy - py) <= 1) {
        continue;
      }
      if (abs(gx - fx) <= 1 && abs(gy - fy) <= 1) {
        continue;
      }
      Direction[] dirs = Direction.values();
      Direction face = dirs[int(random(dirs.length))];
      Goblin g = new Goblin(face);
      this.room[gx][gy] = g;
      this.enemies.add(g);
      placed++;
    }

    this.clearRocksFromDoorTiles();
    this.rebuildPositions();
    this.updateActions(this.player);
  }

  /**
   *      Method: private updateActions()
   *  Parameters: Actor actor - The actor whose actions will be
   *                            updated to reflect their validity
   *      Return: void
   * Description: Updates an actor's list of valid actions
   */

  private void updateActions(Actor actor) {
    for (Action action: Action.values()) {
      actor.setActionValidity(action, this.isActionValid(actor, action));
    }
  }

  /**
   *      Method: public tryTurn()
   *  Parameters: void
   *      Return: boolean - Whether or not the state of
   *                        the scene should be saved
   * Description: Tries to execute a single turn of game
   *              logic for the player and all enemies
   */

  public boolean tryTurn() {
    // If the player is dead, reset the room
    if (this.player == null || this.player.getHealth() == 0) {
      Direction[] directions = Direction.values();
      Direction direction = directions[int(random(directions.length))];
      this.player = new Player(direction);
      this.reset(direction);
    }

    // Get the player's action
    Action action = this.player.getAction();

    // If no action was chosen, do nothing
    if (action == null) {
      return false;
    }

    // If the player attacked or entered a new room, save the game
    Position door = this.doors.get(action.direction);
    boolean save = action.isAttack || door != null && door.equals(this.positions.get(this.player)) && this.enemies.size() == 0;

    // If the action failed, do nothing
    if (!this.tryAction(this.player, action)) {
      return false;
    }

    for (int i = 0; i < this.enemies.size(); ++i) {
      Actor enemy = this.enemies.get(i);

      // Remove dead enemies
      if (enemy.getHealth() == 0) {
        this.enemies.remove(i--);
        continue;
      }

      // Get the enemy's action
      this.updateActions(enemy);
      action = enemy.getAction();

      if (this.tryAction(enemy, action) && action.isAttack) {
        // If the player died, reset the room and save the game
        if (player.getHealth() == 0) {
          Direction[] directions = Direction.values();
          Direction direction = directions[int(random(directions.length))];
          this.player = new Player(direction);
          this.reset(direction);
          return true;
        }

        // If the enemy attacked, save the game
        save = true;
      }
    }

    this.updateActions(this.player);
    return save;
  }

  /**
   *      Method: private tryAction()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action succeeded
   * Description: Tries to execute an action on behalf of an actor
   */

  private boolean tryAction(Actor actor, Action action) {
    if (!isActionValid(actor, action)) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Player steps off through a door (all enemies must be cleared first)
    if (!action.isAttack && actor == this.player && this.enemies.size() == 0) {
      Position door = this.doors.get(action.direction);

      if (door != null && door.equals(position)) {
        this.reset(action.direction);
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      boolean isActionValid = this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);

      if (isActionValid) {
        Actor target = (Actor)this.room[x][y];
        target.updateHealth(-actor.getDamage());
        if (target.getHealth() <= 0) {
          this.room[x][y] = null;
        }
      }

      return isActionValid;
    }

    // Check if the actor can interact with an interactable object
    if (actor == this.player && this.room[x][y] instanceof Interactable) {
      Interactable interactable = (Interactable)this.room[x][y];

      if (!interactable.interact(this.player)) {
        return false;
      }
    } else if (this.room[x][y] != null) {
      return false;
    }

    // Check if the actor can move
    this.room[x][y] = actor;
    this.room[position.getX()][position.getY()] = null;
    position.move(action.direction);
    return true;
  }

  /**
   *      Method: private isActionValid()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action is valid
   * Description: Determines if an actor's action would be valid
   */

  private boolean isActionValid(Actor actor, Action action) {
    if (actor == null || action == null || actor.getHealth() == 0) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Standing on a door tile and moving out through that door (enemies cleared)
    if (!action.isAttack && actor == this.player && this.enemies.size() == 0) {
      Position door = this.doors.get(action.direction);

      if (door != null && door.equals(position)) {
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      return this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);
    }

    // Check if the actor can move
    return this.room[x][y] == null || this.room[x][y] instanceof Interactable && actor == this.player;
  }

  /**
   *      Method: public getRoomWidth()
   *  Parameters: void
   *      Return: int - The width of the room, in number of columns
   * Description: Returns the width of the room
   */

  public int getRoomWidth() {
    return roomWidth;
  }

  /**
   *      Method: public getRoomHeight()
   *  Parameters: void
   *      Return: int - The height of the room, in number of rows
   * Description: Returns the height of the room
   */

  public int getRoomHeight() {
    return roomHeight;
  }

  /**
   *      Method: public keyPressed()
   *  Parameters: void
   *      Return: void
   * Description: Passes key press events to the player
   */

  public void keyPressed() {
    if (this.player != null) {
      this.player.keyPressed();
    }
  }

  /**
   *      Method: public keyReleased()
   *  Parameters: void
   *      Return: void
   * Description: Passes key release events to the player
   */

  public void keyReleased() {
    if (this.player != null) {
      this.player.keyReleased();
    }
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the scene
   */

  public void draw() {
    float size = min((float)width / (this.roomWidth + 2), (float)height / (this.roomHeight + 2));
    pushMatrix();
    float ox = (width - this.roomWidth * size) / 2;
    float oy = (height - this.roomHeight * size) / 2;
    translate(ox, oy);

    // Floor: same grid as before; optional floor.png stretched per tile (still one rect per cell).
    imageMode(CORNER);
    noTint();
    for (int y = 0; y < this.roomHeight; y++) {
      for (int x = 0; x < this.roomWidth; x++) {
        float tx = x * size;
        float ty = y * size;
        if (floorSprite != null && floorSprite.width > 0) {
          image(floorSprite, tx, ty, size, size);
        } else {
          if (this.cellHasDoor(x, y)) {
            fill(45, 50, 68);
          } else {
            fill(28, 26, 38);
          }
          noStroke();
          rect(tx, ty, size, size);
        }
        // Door tint on top of texture so exits stay noticeable
        if (this.cellHasDoor(x, y) && floorSprite != null && floorSprite.width > 0) {
          fill(25, 35, 70, 110);
          noStroke();
          rect(tx, ty, size, size);
        }
        // Grid lines keep tiles visibly separated (assignment asks for clear tiles)
        noFill();
        stroke(65, 65, 80);
        strokeWeight(1);
        rect(tx, ty, size, size);
      }
    }

    // draw each object in the middle of its tile
    for (int y = 0; y < this.roomHeight; y++) {
      for (int x = 0; x < this.roomWidth; x++) {
        WorldObject w = this.room[x][y];
        if (w != null) {
          pushMatrix();
          translate(x * size + size / 2, y * size + size / 2);
          w.draw();
          popMatrix();
        }
      }
    }
    popMatrix();
  }
}
