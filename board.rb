class Board
  NEIGHBOR_VECTORS = [
    [-1,-1],[-1, 0],
    [-1, 1],[0 ,-1],
    [0 , 1],[1 ,-1],
    [1 , 0],[1 , 1]
  ]
  
  # Board is stored as a 2d array containing hashs. Each hash has a display key set to '*'
  # signifing that the square is not revealed. Each hash also has a b: key which
  # is a boolean: true if is is a bomb, false if it is not. 
    
  def self.new_board(size=9)
    new_game = Board.new(Array.new(size) { Array.new(size) { {b: false, display: "*"} } } )
    new_game.set_bombs
    new_game
  end
  
  def initialize(board)
    @board = board
    @lost, @win = false, false
  end

  def display_board
    @board.length.times do | x |
      @board[0].length.times do | y |
        print " #{@board[x][y][:display]} "
      end
      print "\n"
    end
    nil
  end

  def set_bombs
    bombs_coords.each do |coord|
      @board[coord[0]][coord[1]][:b] = true 
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
    @board[coords[0]][coords[1]][:display] = value
  end

  def display_square(coords)
    @board[coords[0]][coords[1]]
  end

  def find_neighbors(coords)
    neighbors = []
    NEIGHBOR_VECTORS.each do |vector|  # Need helper method for unless statement
      unless ((coords[0]+vector[0]) < 0 || (coords[1]+vector[1]) < 0) || ((coords[0]+vector[0]) > 8 || (coords[1]+vector[1]) > 8) 
        checking_x = coords[0]+vector[0]
        checking_y = coords[1]+vector[1]
        neighbors << [checking_x,checking_y]
      end
    end
    neighbors
  end

  def set_flag(coords)
    @board[coords[0]][coords[1]][:display] = "F"
  end

  def expose_square(coords)
    if is_bomb?(coords)
      set_square(coords, "B")
      lose
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
    @board[coords[0]][coords[1]][:b]
  end

  def is_flag?(coords)
    @board[coords[0]][coords[1]][:display] == "F" ? true : false
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
      bomb_num += 1 if @board[neighbor[0]][neighbor[1]][:b]
    end
    bomb_num
  end

  def lose
    @lost = true
  end

  def win
    # Need an all_revealed? helper method
    stars = []
    @board.length.times do | x |
      @board[0].length.times do | y |
        stars << '*' if @board[x][y][:display] == '*'
      end
    end
    @win = true if b.empty?
  end

  def game_over?
    true if @win || @lost
  end

end