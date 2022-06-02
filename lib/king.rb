require_relative 'pieces'

class King 
  include Pieces

  attr_accessor :position, :on_first_move
  attr_reader :piece, :type, :children

  def initialize(piece, position)
    @piece = piece
    @position = position
    @on_first_move = true
    @type = 'king'
    @children = []
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
end