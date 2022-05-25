require_relative 'pieces'

class Knight 
  include Pieces

  attr_reader :position, :piece, :children, :type

  def initialize(piece, position)
    @piece = piece
    @position = position
    @type = 'knight'
    @children = []
  end

  def moves
    [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end

  def make_children
    @children = []
    moves.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      @children.push(child) if child.all? { |n| n.between?(0, 7) }
    end
  end

  def update(position)
    @position = position
    make_children
  end
end