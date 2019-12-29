class Node
  #public members
  # x pos (int)
  # y pos (int)
  # x bound (int)
  # y bound (int)
  # boolean nodeCollision?


  end
class Food < Node
  # method: Respawn()
  # finds a new coordinates for food inside the x and y bound
end

class Link < Node
  # this is the Node extension that MOVES
  # public members:
  # next = a null or Link Object
  # method: move(direction)
  # instructs the node to move one node's length: N S E W
  # if has a next link, then passes direction to that link after a delay
  # method: addLink
  # if next is null, creates a new link node there
  # else, calls the addLink method for Link.next
  end
class Snake
  #initialize ()
  # creates a Link object and sets it as HEAD
  #public members
  # HEAD (snake link)

  # method: turn_left
  # method: turn_right
  # public boolean: eat?
  # if the head of the snake collides with food
  # public boolean: hit?
  # if the head of the snake collides with the wall of the board or a snake link.
  # is a construct that is comprised of Link objects
  end
class Board
  # method: initialize(x width, y width)
  # creates the board size based on size parameters
  # creates a SNAKE object and FOOD object
  # method: Start
  # changes game state from menu screen to play
  # method: Reset
  # changes game state from play to menu screen, method is called in event of a collision
  end
end
class Game
  #initializes the board object
  # will call the methods for the board and snake object based on user input
  # is the interface
end