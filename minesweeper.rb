class Board
  def initialize
    @matrix = Array.new(9) { Array.new(9) { {b: false, v: "*"} } }
    set_bombs
  end

  def set_bombs
    bombs_cords.each do |cord|
      @matrix[cord[0]][cord[1]][:b] = true
    end
  end

  def bombs_cords
    bomb_array = []
    until bomb_array.length == 10
      bomb_cords = [rand(9), rand(9)]
      unless bomb_array.include?(bomb_cords)
        bomb_array << bomb_cords
      end
    end
    p bomb_array
  end

  def set_square(x,y, value)
    @matrix[x][y] = value
  end

  def display_square(x,y)
    @matrix[x][y]
  end

  def find_neighbors(x,y)
    # find the 8 neighbors of x,y
    vectors = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]

    vectors.each do |vector|
      unless ((x+vector[0]) < 0 || (y+vector[1]) < 0) || ((x+vector[0]) > 8 || (y+vector[1]) > 8)

        checking_x = x+vector[0]
        checking_y = y+vector[1]
        # here is where we would have rules to change display key
        puts @matrix[checking_x][checking_y]

      end
    end
  end

end