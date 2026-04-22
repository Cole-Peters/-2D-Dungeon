/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Position.pde
 * Description: A cell-based position in a room
 */

class Position {
  private int x;
  private int y;
  private Scene scene;

  /**
   * Constructor: public Position()
   *  Parameters: int   x     - The X component of the position
   *              int   y     - The Y component of the position
   *              Scene scene - The scene that contains a room
   * Description: Constructs a position in a room
   */

  public Position(int x, int y, Scene scene) {
    this.x = constrain(x, 0, scene.getRoomWidth() - 1);
    this.y = constrain(y, 0, scene.getRoomHeight() - 1);
    this.scene = scene;
  }

  /**
   *      Method: public getX()
   *  Parameters: void
   *      Return: int - The X component of the position
   * Description: Returns the X component of the position
   */

  public int getX() {
    return x;
  }

  /**
   *      Method: public getY()
   *  Parameters: void
   *      Return: int - The Y component of the position
   * Description: Returns the Y component of the position
   */

  public int getY() {
    return y;
  }

  /**
   *      Method: public equals()
   *  Parameters: Position other - The position to compare to
   *      Return: boolean - Whether or not the positions are equivalent
   * Description: Returns whether or not two positions are equivalent
   */

  public boolean equals(Position other) {
    return other != null && this.x == other.getX() && this.y == other.getY();
  }

  /**
   *      Method: public move()
   *  Parameters: Direction direction - The direction to move in
   *      Return: void
   * Description: Moves in a direction, constrained to the size of the room
   */

  public void move(Direction direction) {
    if (direction != null) {
      this.x = constrain(this.x + direction.x, 0, this.scene.getRoomWidth() - 1);
      this.y = constrain(this.y + direction.y, 0, this.scene.getRoomHeight() - 1);
    }
  }
}
