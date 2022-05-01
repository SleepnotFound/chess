require_relative 'pieces'

class King 
  include Pieces

  attr_reader :position, :piece

  def initialize(position, piece)
    @position = position
    @piece = piece
    @children = []
  end

  def moves
    [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  end
end