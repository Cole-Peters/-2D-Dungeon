/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Interactable.pde
 * Description: Base class for all interactable objects that can be
 *              interacted with by the player but not other actors
 */

abstract class Interactable extends WorldObject {
  /**
   *      Method: public interact()
   *  Parameters: Player player - The player interacting with the object
   *      Return: boolean - Whether or not the interaction succeeded
   * Description: Attempts to interact with the object
   */

  public abstract boolean interact(Player player);
}
