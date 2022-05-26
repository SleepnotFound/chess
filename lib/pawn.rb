require_relative 'pieces'

class Pawn 
  include Pieces

  attr_accessor :position, :passant
  attr_reader :piece, :type, :children, :on_first_move

  def initialize(piece, position)
    @piece = piece
    @position = position
    @type = 'pawn'
    @on_first_move = true
    @passant = false
    @children = []
  end

  def moves
    [[-1,0], [-1,-1], [-1,1]]
  end

  def make_children
    @children = []
    moveset = moves
    moveset << [-2,0] if on_first_move
    moveset.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      @children.push(child) if child.all? { |n| n.between?(0, 7) }
    end
  end
end