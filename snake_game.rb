require 'gosu'

class Player
  def initialize(letter, vel)
    @image = Gosu::Image.from_text(letter, 16) #much better
    @x = @y = @vel_x = @vel_y = @angle = 0
    @vel = vel
    # would like to read the opening lines from 'Through the Looking Glass' to build the snake.
  end
  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    if @vel_x==0
      @vel_x =  @vel
      @vel_y = 0
    end
  end
 
  def turn_right
    # @angle += 4.5
    if @vel_x == 0
      @vel_x = -@vel
      @vel_y = 0
    end
  end

  def turn_up
    if @vel_y == 0
      @vel_y = @vel
      @vel_x = 0
    end
  end

  def turn_down
    if @vel_y == 0
      @vel_y = -@vel
      @vel_x = 0
    end
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    #below we have a deceleration thingy
    #  @vel_x *= 0.95
    # @vel_y *= 0.95
  end

  def draw()
    @image.draw_rot(@x, @y, 1, @angle) # diverging from tutorial here
  end
end
  #public members
  # x pos (int)
  # y pos (int)
  # x bound (int)
  # y bound (int)
  # boolean nodeCollision?


class Board < Gosu::Window
  def initialize
    super 640, 480
    @player = Player.new('A', -3)
    @player.warp(320, 240) # note the relationhip between this and board size
    self.caption = "Word Snake"
  end
  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu.button_down? Gosu::GP_LEFT
       @player.turn_left

    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu.button_down? Gosu::GP_RIGHT
      @player.turn_right
    end

    if Gosu.button_down? Gosu::KB_DOWN or Gosu.button_down? Gosu::GP_DOWN
      @player.turn_down
    end
     if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_0
    #   @player.accelerate
       @player.turn_up
     end
    @player.move
  end
  def draw
    @player.draw()
  end

  #keep this snippet : very handy
  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
      end
    end
  end

  # method: initialize(x width, y width)
  # creates the board size based on size parameters
  # creates a SNAKE object and FOOD object
  # method: Start
  # changes game state from menu screen to play
  # method: Reset
  # changes game state from play to menu screen, method is called in event of a collision


Board.new.show

