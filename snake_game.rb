require 'gosu'

class Player
  def initialize(letter, vel)
    @image = Gosu::Image.from_text(letter, 16) #much better?
    @cord_x = @cord_y = @vel_x = @vel_y = @angle = 0
    @vel = vel
    # would like to read the opening lines from 'Through the Looking Glass' to build the snake.
  end
  def get_x_cord
    @cord_x
  end
  def get_y_cord
    @cord_y
  end
  def warp(x, y)
    @cord_x, @cord_y = x, y
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
    @cord_x += @vel_x
    @cord_y += @vel_y
    @cord_x %= 640
    @cord_y %= 480

    #below we have a deceleration thingy
    #  @vel_x *= 0.95
    # @vel_y *= 0.95
  end

  def draw()
    @image.draw_rot(@cord_x, @cord_y, 1, @angle) # diverging from tutorial here
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
    @player.warp(320, 480) # note the relationship between this and board size
    self.caption = "Word Snake"
    @font = Gosu::Font.new(20)
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
       @player.turn_up
     end
    #if player exceeds boundaries, put back in center
    @player.move
  end
  def draw
    @player.draw()
    @font.draw_text("cords: #{@player.get_x_cord}, #{@player.get_y_cord}", 10, 10, 2, 1.0, 1.0, Gosu::Color::YELLOW)
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

