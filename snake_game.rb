require 'ruby2d'
set background: 'black' #like the idea of yellow bg and fuchsia squares
set fps_cap: 15
set title: 'Rainbow Snake'
GRID_SIZE = 20
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE - 2
COLORS = ['yellow', 'aqua','orange', 'red', 'fuchsia', 'silver']
#window is 640 by 480
# so grid is 32 by 24
class Snake

  attr_writer :new_direction

  def initialize
    #starting position and heading of snake is the same every time
    @position = [[16, 22], [16, 21], [16, 20]]
    @direction = 'up'
    @growing = false
    @snake_colors = ['white', 'yellow', 'red'] #starter colors to make best impression to new players
  end

  def draw
    #iterate backwards through snake to re-draw and append colors in the correct order
    num = @position.length - 1
    @position.each do |pos|
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: @snake_colors[num])
      num -= 1
    end
  end

  def direction
    @direction
  end

  def new_direction(dir)
    @direction = dir
  end
  def move
    @position.shift unless @growing
    case @direction
    when 'down'
      @position.push([head[0], head[1]+1])
    when 'up'
      @position.push([head[0], head[1]-1])
    when 'left'
      @position.push([head[0] - 1, head[1]])
    when 'right'
      @position.push([head[0] + 1, head[1]])
    end
    @growing = false
  end

  def get_pos
    @position
  end

  def head
    @position.last
  end

  def x
    head[0]
  end

  def y
    head[1]
  end

  def grow(color)
    @snake_colors.push(color)
    @growing = true
  end

  def collision? #collision detection is not working as expected
    (@position.uniq.length != @position.length)
  end

end
#the game class, tracks score and displays feedback for player
class Game
  def initialize
    @score = 0
    @food_x = rand(GRID_WIDTH) # may want a second method to spawn food to not to interfere with snake
    @food_y = rand(GRID_HEIGHT)
    @finished = false
    @food_color = COLORS.sample
    @menu = true
  end
  def draw
    unless finished? or menu?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: NODE_SIZE, color: @food_color)
    end
    if finished?
      msg = 'Dead snake. Press RETURN to play again.'
    else
      msg = "Score: #{@score}"
    end
    Text.new(msg, color: 'black', x: 11, y: 11, size: 25)
    Text.new(msg, color: 'white', x: 10, y: 10, size: 25)
    if menu?
      hue = COLORS.sample
      Text.new('RAINBOW SNAKE', color: hue, x: 10, y: 40, size: 72)
      Text.new('press SPACE to play', color: 'white', x: 160, y: 160, size: 35)
    end
  end
  def remove_menu
    @menu = false
  end
  def snake_eat_food?(x, y)
    @food_x == x && @food_y == y
  end
  def get_food_color
    @food_color
  end
  def record_hit(pos)
    @score +=1
    @food_color = COLORS.sample
    @food_x = rand(GRID_WIDTH)
    @food_y = rand(GRID_HEIGHT)
    while pos.include?([@food_x, @food_y])
      @food_x = rand(GRID_WIDTH)
      @food_y = rand(GRID_HEIGHT)
    end
  end
  def finish
    @finished = true
  end
  def menu?
    @menu
  end
  def finished?
    @finished
  end
end

game = Game.new
snake = Snake.new
snake.draw
update do
  #the cycle
  clear
  snake.move unless game.finished? or game.menu?
  snake.draw
  game.draw

  if game.snake_eat_food?(snake.x, snake.y)
    snake.grow(game.get_food_color)
    game.record_hit(snake.get_pos)
  end

  if snake.collision? || snake.head[0] < 0 || snake.head[1] < 0 || snake.head[0] == GRID_WIDTH || snake.head[1] == GRID_HEIGHT
    game.finish
  end
end

on :key_down do |event|
  snake.new_direction('left') if event.key == 'left' && snake.direction != 'right'
  snake.new_direction('right') if event.key =='right'&& snake.direction != 'left'
  snake.new_direction('up') if event.key == 'up' && snake.direction != 'down'
  snake.new_direction ('down') if event.key == 'down' && snake.direction != 'up'
  if event.key == 'return'
    snake = Snake.new
    game = Game.new
  end
  close if event.key == 'escape'
  game.remove_menu if event.key = 'space'
end
show
