require_relative './board.rb'
require 'json'

class Minesweeper
  def initialize  
    load_game
  end

  def load_game
    puts "New Game or Load Game? (n/l)" 
    start = gets.chomp.downcase

    if start=='l'
      load_file
    else
      @board = Board.new_board
    end
  end

  def play
    until @board.game_over?
      @board.display_board
      prompt_user
    end
    @board.display_board
    puts "Game over!" # add won or lost
  end

  def prompt_user
    puts "Reveal a square or flag a square? (r/f/s)\n"
    type_of_action = gets.chomp.downcase

    save if type_of_action == 's'

    puts "Pick a Coordinate" # user enters two numbers, one space, no comma
    coord = gets.chomp.split(' ').map(&:to_i)
    if type_of_action == 'f'
      @board.set_flag(coord)
    elsif type_of_action == 'r'
      @board.expose_square(coord)
    end
  end

  def load_file
    json = File.read('game.json')
    board_array = JSON.parse(json, symbolize_names: true)[:board]
    @board = Board.new(board_array)
  end

  def save
    File.open("game.json", "w") do |f|
      test = {"board" => @board.matrix }
      f.puts test.to_json
    end
    puts "Goodbye!"
    exit
  end
end


if __FILE__ == $PROGRAM_NAME
  m = Minesweeper.new
  m.play
end



