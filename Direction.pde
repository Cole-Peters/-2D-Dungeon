/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Direction.pde
 * Description: The set of cardinal directions
 */

enum Direction {
  NORTH(0, -1),
  SOUTH(0, 1),
  EAST(1, 0),
  WEST(-1, 0);

  public final int x;
  public final int y;

  /**
   * Constructor: public Direction()
   *  Parameters: int x - The X positional offset
   *              int y - The Y positional offset
   * Description: Constructs a direction from given
   *              X and Y positional offsets
   */

  private Direction(int x, int y) {
    this.x = x;
    this.y = y;
  }

  /**
   *      Method: public inverse()
   *  Parameters: void
   *      Return: Direction - The inverse direction
   * Description: Inverts the direction, such as from
   *              north to south or east to west
   */

  public Direction inverse() {
    switch (this) {
    case NORTH:
      return SOUTH;

    case SOUTH:
      return NORTH;

    case EAST:
      return WEST;

    case WEST:
      return EAST;

    default:
      return null;
    }
  }
}
