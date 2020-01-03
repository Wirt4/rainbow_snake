require 'ruby2d'
set background: 'black' #like the idea of yellow bg and fuchsia squares
set fps_cap: 12
GRID_SIZE = 20
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
NODE_SIZE = GRID_SIZE - 1
COLORS = ['gray', 'yellow', 'orange', 'red', 'fuchsia', 'silver']
#window is 640 by 480
# so grid is 32 by 24
class Snake

  attr_writer :direction

  def initialize
    @position = [[16, 23], [16, 22], [16, 21]]
    @direction = 'up'
    @growing = false
    @snake_colors = []
    for num in 1..3 do
      @snake_colors.push(COLORS.sample)
    end
  end

  def draw
    num = @position.length - 1
    @position.each do |pos|
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: NODE_SIZE, color: @snake_colors[num])
      num -= 1
    end
  end
  def get_dir
    @direction
  end
  def set_dir(dir)
    @direction = dir
  end
  def move
    unless @growing
      @position.shift
    end
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
      Text.new('SNAKE RAINBOW', color: hue, x: 10, y: 40, size: 72)
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
  snake.set_dir('left') if event.key == 'left' && snake.get_dir != 'right'
  snake.set_dir('right') if event.key =='right'&& snake.get_dir != 'left'
  snake.set_dir('up') if event.key == 'up' && snake.get_dir != 'down'
  snake.set_dir ('down') if event.key == 'down' && snake.get_dir != 'up'
  if event.key == 'return'
    snake = Snake.new
    game = Game.new
  end
  close if event.key == 'escape'
  game.remove_menu if event.key = 'space'
end
show
