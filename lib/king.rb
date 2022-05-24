require_relative 'pieces'

class King 
  include Pieces

  attr_reader :position, :piece, :children, :type

  def initialize(piece, position)
    @piece = piece
    @position = position
    @type = 'king'
    @children = []
    make_children
  end

  def moves
    [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  end

  def make_children
    @children = []
    moves.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      if child.all? { |n| n.between?(0, 7) }
        @children.push(child)
      end
    end
  end

  def update(position)
    @position = position
    make_children
  end
end