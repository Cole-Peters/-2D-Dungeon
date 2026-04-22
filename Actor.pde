/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Actor.pde
 * Description: Base class for all actors that can perform actions
 */

abstract class Actor extends WorldObject {
  private int maxHealth;
  private int currHealth;
  private int damage;
  protected Direction facing;
  protected HashMap<Action, Boolean> validActions;

  /**
   * Constructor: public Actor()
   *  Parameters: int       health - The health value of the actor
   *              int       damage - The damage value of the actor
   *              Direction facing - The direction the actor is facing
   * Description: Constructs an actor
   */

  public Actor(int health, int damage, Direction facing) {
    this.maxHealth = health;
    this.currHealth = health;
    this.damage = damage;
    this.facing = facing;
    this.validActions = new HashMap<Action, Boolean>();
  }

  /**
   * Constructor: public Actor()
   *  Parameters: JSONObject object - A JSON serialization of the actor
   * Description: Constructs an actor from JSON save data
   */

  public Actor(JSONObject object) {
    this.maxHealth = object.getInt("maxHealth");
    this.currHealth = object.getInt("currHealth");
    this.damage = object.getInt("damage");
    this.facing = Direction.valueOf(object.getString("facing"));
    this.validActions = new HashMap<Action, Boolean>();
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the object to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setInt("maxHealth", this.maxHealth);
    object.setInt("currHealth", this.currHealth);
    object.setInt("damage", this.damage);
    object.setString("facing", this.facing.name());
    return object;
  }

  /**
   *      Method: public getHealth()
   *  Parameters: void
   *      Return: float - The health of the actor as
   *                      a percentage from 0 to 1
   * Description: Returns the health of the actor
   */

  public float getHealth() {
    return map(this.currHealth, 0, this.maxHealth, 0, 1);
  }

  /**
   *      Method: public getDamage()
   *  Parameters: void
   *      Return: int - The damage dealt by the actor
   * Description: Returns the damage dealt by the actor
   */

  public int getDamage() {
    return this.damage;
  }

  /**
   *      Method: public updateHealth()
   *  Parameters: int change - The amount of health to update
   *                           by, clamped between 0 and the
   *                           actor's maximum health value
   *      Return: void
   * Description: Updates the health value of the actor
   */

  public void updateHealth(int change) {
    this.currHealth = constrain(this.currHealth + change, 0, this.maxHealth);
  }

  /**
   *      Method: public getActionValidity()
   *  Parameters: Action action - The selected action to perform
   *      Return: boolean - Whether or not the action is valid
   * Description: Checks whether or not an action is valid
   */

  public boolean getActionValidity(Action action) {
    return action == null || this.validActions.getOrDefault(action, false);
  }

  /**
   *      Method: public setActionValidity()
   *  Parameters: Action  action - The action to set
   *              boolean valid  - Whether or not the action is valid
   *      Return: void
   * Description: Sets whether or not an action is valid
   */

  public void setActionValidity(Action action, boolean valid) {
    if (action != null) {
      this.validActions.put(action, valid);
    }
  }

  /**
   *      Method: public getAction()
   *  Parameters: void
   *      Return: Action - The selected action to perform
   * Description: Selects an action to perform
   */

  abstract public Action getAction();
}
