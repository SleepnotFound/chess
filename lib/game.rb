require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Game 
  include Pieces

  attr_accessor :board, :player1, :player2, :active_player
  
  def initialize
    @board = Board.new
    @player1 = Player.new(white)
    @player2 = Player.new(black)
    @active_player = self.player1
  end

  def play
    name_players
    set_game_pieces
    self.board.build_board
    p self.active_player
  end

  def set_game_pieces
    #temp initialized pieces todo: set player pieces based on save file or default newgame
    t1 = King.new(white + king, [4,7])
    t2 = King.new(black + king, [4,0])
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
    puts "Player #{id}, what is you name?"
    gets.chomp
  end
end