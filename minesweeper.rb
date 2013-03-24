require_relative './board.rb'
require 'json'

class Minesweeper
  def initialize    #REV this constructor doesn't actually do anything, so its not required
    @board
  end

  def load_game
    puts "New Game or Load Game? (n/l)"   #REV the prompt here is nice
    start = gets.chomp.downcase

    if start=='l'
      load_file
    else
      @board = Board.new
      @board.set_bombs  #REV a bit weird that you call set_bombs and this is not done on Board construction
    end
    play
  end

  def play
    until @board.game_over?
      @board.display_board
      prompt_user
    end
    @board.display_board
    puts "Game over!"     #REV might be nice to know if user won or lost
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

#REV file is over 200 lines long, definitely benefit from moving the classes into separate files

=begin
REV The way Minesweeper is made now, it is a little error prone. For example, the user could do
Minesweeper.new.play, in which case the @board is nil and program will crash. Consider making the
constructor of Minesweeper protected, and use factory methods to create an instance of Minesweeper.
for example:

def self.new_game
  Minesweeper.new(Board.new)
end

protected
def initialize(board)
  @board = board
end

REV great job overall
=end

m = Minesweeper.new
m.load_game



