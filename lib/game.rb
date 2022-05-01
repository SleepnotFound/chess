require_relative 'board'

class Game 
  attr_reader :board
  
  def initialize
    @board = Board.new
  end

  def play
    self.board.display_board
  end
end