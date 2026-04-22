/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Player.pde
 * Description: A user-controlled player actor
 */

class Player extends Actor {
  private char nextKey;
  private HashMap<Character, Boolean> debounce;

  /**
   * Constructor: public Player()
   *  Parameters: Direction direction - The direction to face
   * Description: Constructs a player in a new room
   */

  public Player(Direction direction) {
    super(100, 10, direction);
    this.nextKey = '\0';
    this.debounce = new HashMap<Character, Boolean>();
  }

  /**
   * Constructor: public Player()
   *  Parameters: JSONObject object - A JSON serialization of the player
   * Description: Constructs a player from JSON save data
   */

  public Player(JSONObject object) {
    super(object);
    this.nextKey = '\0';
    this.debounce = new HashMap<Character, Boolean>();
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the object to JSON
   */

  public JSONObject serialize() {
    JSONObject object = super.serialize();
    object.setString("className", "Player");
    return object;
  }

  /**
   *      Method: public getAction()
   *  Parameters: void
   *      Return: Action - The selected action to perform
   * Description: Selects an action to perform
   */

  public Action getAction() {
    char currKey = this.nextKey;
    this.nextKey = '\0';
    Action action = null;

    // Convert key to action
    switch (currKey) {
    case 'W':
      this.facing = Direction.NORTH;
      action = Action.MOVE_NORTH;
      break;

    case 'S':
      this.facing = Direction.SOUTH;
      action = Action.MOVE_SOUTH;
      break;

    case 'D':
      this.facing = Direction.EAST;
      action = Action.MOVE_EAST;
      break;

    case 'A':
      this.facing = Direction.WEST;
      action = Action.MOVE_WEST;
      break;

    case ' ':
      switch (this.facing) {
      case NORTH:
        action = Action.ATTACK_NORTH;
        break;

      case SOUTH:
        action = Action.ATTACK_SOUTH;
        break;

      case EAST:
        action = Action.ATTACK_EAST;
        break;

      case WEST:
        action = Action.ATTACK_WEST;
        break;
      }

      break;
    }

    // Check if the action can be performed
    return this.getActionValidity(action) ? action : null;
  }

  /**
   *      Method: public keyPressed()
   *  Parameters: void
   *      Return: void
   * Description: Handles key release events with debouncing
   */

  public void keyPressed() {
    // Convert to uppercase
    char pressed = Character.toUpperCase(key);

    if ("WASD ".indexOf(pressed) != -1 && !debounce.getOrDefault(pressed, false)) {
      debounce.put(pressed, true);
      nextKey = pressed;
    }
  }

  /**
   *      Method: public keyReleased()
   *  Parameters: void
   *      Return: void
   * Description: Handles key release events with debouncing
   */

  public void keyReleased() {
    // Convert to uppercase
    char released = Character.toUpperCase(key);

    if (debounce.getOrDefault(released, false)) {
      debounce.put(released, false);
    }
  }
}
