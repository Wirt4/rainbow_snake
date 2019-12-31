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
    @position = [[16, 21], [16, 22], [16,23]]
    @direction = 'up'
  end

  def draw
    # Square.new(x: 2* GRID_SIZE, y: 0, size: GRID_SIZE, color: 'maroon')
    #
    @position.each do |pos|
      Square.new(x: pos[0]* GRID_SIZE, y: pos[1]* GRID_SIZE, size: GRID_SIZE, color: 'maroon')
    end
  end
  def get_dir
    @direction
  end
  def set_dir(dir)
    @direction = dir
  end
  def move
    @position.shift
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
  end

  def head
    @position.last
  end

  private
  def new_cords(x,y) #this is infinite pac - man space, will want to amend this
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end
end

snake = Snake.new
snake.draw
update do
  #the cycle
  clear
  snake.move
  snake.draw
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
