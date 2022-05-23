require_relative 'pieces'

class Pawn 
  include Pieces

  attr_reader :position, :piece, :children, :type, :on_first_move

  MOVES = [[-1,0], [-1,-1], [-1,1]].freeze

  def initialize(piece, position)
    @piece = piece
    @position = position
    @type = 'pawn'
    @on_first_move = true
    @passant = false
    @children = []
    make_children
  end

  def make_children
    @children = []
    moves = Pawn::MOVES.dup
    moves << [-2,0] if on_first_move
    moves.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      @children.push(child) if child.all? { |n| n.between?(0, 7) }
    end
  end

  def update(position)
    @position = position
    @on_first_move = false
    make_children
  end
end