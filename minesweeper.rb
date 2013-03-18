class Board

  def initialize
    @matrix = Array.new(9) { Array.new(9) }
  end

  def set_square(x,y, value)
    @matrix[x][y] = value
  end

  def display_square(x,y)
    @matrix[x][y]
  end

end