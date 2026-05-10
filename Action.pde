/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Action.pde
 * Description: The set of actions that can be performed
 */

enum Action {
  MOVE_NORTH(Direction.NORTH, false),
  MOVE_SOUTH(Direction.SOUTH, false),
  MOVE_EAST(Direction.EAST, false),
  MOVE_WEST(Direction.WEST, false),
  ATTACK_NORTH(Direction.NORTH, true),
  ATTACK_SOUTH(Direction.SOUTH, true),
  ATTACK_EAST(Direction.EAST, true),
  ATTACK_WEST(Direction.WEST, true);

  public final Direction direction;
  public final boolean isAttack;

  /**
   * Constructor: public Action()
   *  Parameters: Direction direction - The direction the action is performed in
   *              boolean   isAttack  - Whether or not the action is an attack
   * Description: Constructs an action from a direction and purpose
   */

  private Action(Direction direction, boolean isAttack) {
    this.direction = direction;
    this.isAttack = isAttack;
  }
}
