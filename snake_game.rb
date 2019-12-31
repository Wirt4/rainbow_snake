require 'ruby2d'
set background: 'yellow' #like the idea of yellow bg and fuchsia squares
GRID_SIZE = 20
#window is 640 by 480
# so grid is 32 by 24
class Snake
  def initialize
    @position = [[2, 0], [2, 1], [2, 2], [2, 3]]
  end

  def draw
    # Square.new(x: 2* GRID_SIZE, y: 0, size: GRID_SIZE, color: 'maroon')
    @position.each do |pos|
      Square.new(x: pos[0]* GRID_SIZE, y: pos[1]* GRID_SIZE, size: GRID_SIZE, color: 'maroon')
    end
  end
end

snake = Snake.new
snake.draw
show
