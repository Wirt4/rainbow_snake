require 'gosu'

class Node
  def initialize(letter)
    @x = @y = 0
    @image = Gosu::Image.from_text(letter, 12) #much better
    # would like to read the opening lines from 'Through the Looking Glass' to build the snake.
  end
  def draw(x, y)
    @image.draw_rot(x, y, 1, 0) # diverging from tutorial here
  end
  end
  #public members
  # x pos (int)
  # y pos (int)
  # x bound (int)
  # y bound (int)
  # boolean nodeCollision?

class Food < Node
  # method: Respawn()
  # finds a new coordinates for food inside the x and y bound
end

class Link < Node
  def initialize( letter, x_vel, y_vel)
    super(letter)
    @x_vel=x_vel
    @y_vel=y_vel
  end
  def turn(dir) # -1 for left, +1 for right
    if @x_vel==0
      @x_vel = dir*@y_vel
      @y_vel =0
    else
      @y_vel = -1*dir*@x_vel
      @x_vel=0
    end
  end
  def move
    @x += @x_vel
    @y += @y_vel

  end
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
class Board < Gosu::Window
  def initialize
    super 640, 480
    @node = Link.new('O', 30, 1,)
    self.caption = "Space Train"
  end
  def draw
    @node.draw(320, 240)
  end
  def update
    @node.move
  end
  # method: initialize(x width, y width)
  # creates the board size based on size parameters
  # creates a SNAKE object and FOOD object
  # method: Start
  # changes game state from menu screen to play
  # method: Reset
  # changes game state from play to menu screen, method is called in event of a collision
end
class Game
  #initializes the board object
  # will call the methods for the board and snake object based on user input
  # is the interface
end

Board.new.show

