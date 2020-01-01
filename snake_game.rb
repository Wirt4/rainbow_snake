require 'ruby2d'
set background: 'yellow' #like the idea of yellow bg and fuchsia squares
set fps_cap: 12
GRID_SIZE = 20
GRID_WIDTH = Window.width/GRID_SIZE
GRID_HEIGHT = Window.height/GRID_SIZE
#window is 640 by 480
# so grid is 32 by 24
class Snake
  attr_writer :direction

  def initialize
    @position = [[16, 21], [16, 22], [16, 23]]
    @direction = 'up'
    @growing = false
  end

  def draw
    @position.each do |pos|
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: GRID_SIZE, color: 'maroon')
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
      @position.push(new_cords(head[0], head[1]+1))
    when 'up'
      @position.push(new_cords(head[0], head[1]-1))
    when 'left'
      @position.push(new_cords(head[0] - 1, head[1]))
    when 'right'
      @position.push(new_cords(head[0] + 1, head[1]))
    end
    @growing = false
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

  def grow
    @growing = true
  end

  def collision? #collision detection is not working as expected
    @position.uniq.length == @position.length
  end

  private
  def new_cords(x,y) #this is infinite pac - man space, will want to amend this
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end
end

class Game
  def initialize
    @score = 0
    @food_x = rand(GRID_WIDTH) # may want a second method to spawn food to not to interfere with snake
    @food_y = rand(GRID_HEIGHT)
    @finished = false
  end
  def draw
    unless finished?
      Square.new(x: @food_x* GRID_SIZE, y: @food_y * GRID_SIZE, size: GRID_SIZE, color: 'fuchsia')
      end
    Text.new("Score: #{@score}", color: 'black', x: 10, y: 10, size: 25)
  end

  def snake_eat_food?(x, y)
    @food_x == x && @food_y == y
  end

  def record_hit
    @score +=1
    @food_x = rand(GRID_WIDTH)
    @food_y = rand(GRID_HEIGHT)
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end
end

snake = Snake.new
game = Game.new
snake.draw
update do
  #the cycle
  clear
  snake.move #unless game.finished?
  snake.draw
  game.draw

  if game.snake_eat_food?(snake.x, snake.y)
    game.record_hit
    snake.grow
  end

  if snake.collision?
    game.finish
  end
end

on :key_down do |event|
  #will want to re-write the logic here to make snake work on just two keys, left and right
  # if ['up', 'down', 'left','right'].include?(event.key)
  #  snake.direction = event.key
  # end
  if  event.key == 'left'
    case snake.get_dir
    when 'right'
      snake.set_dir('up')
    when 'up'
      snake.set_dir('left')
    when 'left'
      snake.set_dir('down')
    when 'down'
      snake.set_dir('right')
    end
  end
  if  event.key == 'right'
    case snake.get_dir
    when 'right'
      snake.set_dir('down')
    when 'up'
      snake.set_dir('right')
    when 'left'
      snake.set_dir('up')
    when 'down'
      snake.set_dir('left')
    end
  end
end
show
