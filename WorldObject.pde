/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: WorldObject.pde
 * Description: Base class for all objects that can exist in a scene
 */

abstract class WorldObject {
  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the object to JSON
   */

  abstract public JSONObject serialize();

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the object
   */

  abstract public void draw();
}
