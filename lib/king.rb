require_relative 'pieces'

class King 
  include Pieces

  attr_reader :position, :piece, :children

  def initialize(piece, position)
    @piece = piece
    @position = position
    @children = []
    make_children(position)
  end

  def moves
    [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  end

  def make_children(position)
    moves.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      @children.push(child) if child.all? { |n| n.between?(0, 7) }
    end
  end
end