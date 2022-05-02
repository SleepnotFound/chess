require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Game 
  include Pieces

  attr_accessor :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new
    @player2 = Player.new
  end

  def play
    name_players
    set_game_pieces
    self.board.build_board
    self.board.display_board
  end

  def set_game_pieces
    temp_set_white = King.new([4,7], white + king)
    temp_set_black = King.new([4,0], black + king)
    self.board.white_pieces << temp_set_white
    self.board.black_pieces << temp_set_black
  end

  def name_players
    @player1.name = set_names(1)
    @player2.name = set_names(2)
  end

  def set_names(id)
    puts "Player #{id} what is you name?"
    gets.chomp
  end
end