require_relative 'pieces'

class King 
  include Pieces

  attr_reader :position, :piece

  def initialize(piece, position)
    @piece = piece
    @position = position
    @children = []
  end

  def moves
    [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  end
end