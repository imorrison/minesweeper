class Board
  def initialize
    @matrix = Array.new(9) { Array.new(9) { {b: false, display: "*"} } }
    set_bombs
  end

  def display_board
    @matrix.length.times do | x |
      @matrix[0].length.times do | y |
        print " #{@matrix[x][y][:display]} "
      end
      print "\n"
    end
    nil
  end

  def set_bombs
    bombs_coords.each do |coord|
      @matrix[coord[0]][coord[1]][:b] = true
    end
  end

  def bombs_coords
    bomb_array = []
    until bomb_array.length == 10
      bomb_coords = [rand(9), rand(9)]
      unless bomb_array.include?(bomb_coords)
        bomb_array << bomb_coords
      end
    end
    bomb_array
  end

  def set_square(coords, value)
    @matrix[coords[0]][coords[1]][:display] = value
  end

  def display_square(coords)
    @matrix[coords[0]][coords[1]]
  end

  def find_neighbors(coords)
    vectors = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
    neighbors = []
    vectors.each do |vector|
      unless ((coords[0]+vector[0]) < 0 || (coords[1]+vector[1]) < 0) || ((coords[0]+vector[0]) > 8 || (coords[1]+vector[1]) > 8)
        checking_x = coords[0]+vector[0]
        checking_y = coords[1]+vector[1]
        neighbors << [checking_x,checking_y]
      end
    end
    neighbors
  end

  def set_flag(coords)
    @matrix[coords[0]][coords[1]][:display] = "F"
  end

  def expose_square(coords)
    if is_bomb?(coords)
      puts "Game over: bomb found in #{coords}"
    elsif is_flag?(coords)
      puts "That is a Flag, pick another square!"
    elsif exposed?(coords)
      puts "Exposed, pick another square!"
    else
      update_square(coords)
    end
  end

  def exposed?(coords)
    current_state = display_square(coords)[:display]
    current_state.is_a?(Fixnum) ? true : false
  end

  def is_bomb?(coords)
    @matrix[coords[0]][coords[1]][:b]
  end

  def is_flag?(coords)
    @matrix[coords[0]][coords[1]][:display] == "F" ? true : false
  end

  def update_square(coord)
    neighbors = find_neighbors(coord)
    bomb_num = neighbor_bomb_count(neighbors)
    set_square(coord, bomb_num)
    check_neighbors(neighbors) if bomb_num == 0
  end

  def check_neighbors(neighbors)
    neighbors.each do | neighbor |
      next if display_square(neighbor)[:b]
      next if display_square(neighbor)[:display].is_a?(Fixnum)
      update_square(neighbor)
    end
  end

  def neighbor_bomb_count(neighbors)
    bomb_num = 0
    neighbors.each do |neighbor|
      bomb_num += 1 if @matrix[neighbor[0]][neighbor[1]][:b]
    end
    bomb_num
  end
end

class Minesweeper

end