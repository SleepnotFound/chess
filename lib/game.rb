require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Game 
  include Pieces

  attr_accessor :board, :player1, :player2
  
  def initialize
    @board = Board.new
    @player1 = Player.new(white)
    @player2 = Player.new(black)
  end

  def play
    name_players
    set_game_pieces
    self.board.build_board
    self.board.display_board
  end

  def set_game_pieces
    t1 = King.new([4,7], white + king)
    t2 = King.new([4,0], black + king)
    self.player1.pieces << t1
    self.player2.pieces << t2
    self.board.white_pieces << self.player1.pieces[0]
    self.board.black_pieces << self.player2.pieces[0]
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