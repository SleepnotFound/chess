require_relative 'pieces'

class King 
  include Pieces

  attr_reader :position, :piece, :children

  def initialize(piece, position)
    @piece = piece
    @position = position
    @children = []
  end

  def moves
    [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  end

  def make_children
    moves.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      if child.all? { |n| n.between?(0, 7) }
        #logic code here. where to move king without being in check
        @children.push(child)
      end
    end
  end
end