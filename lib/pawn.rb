require_relative 'pieces'

class Pawn 
  include Pieces

  attr_accessor :position, :passant, :on_first_move
  attr_reader :piece, :type, :c_children, :m_children

  def initialize(piece, position)
    @piece = piece
    @position = position
    @type = 'pawn'
    @on_first_move = true
    @passant = false
    @c_children = []
    @m_children = []
  end

  def moves
    if on_first_move
      [[-1,0], [-2,0], [-1,-1], [-1,1]]
    else
      [[-1,0], [-1,-1], [-1,1]]
    end
  end

  def make_children
    @c_children = []
    @m_children = []
    moveset = moves
    inverse_moves(moveset) if @piece.include?(black)
    moveset.each_with_index do |move, i|
      child = [position[0] + move[0], position[1] + move[1]]
      if on_first_move && child.all? { |n| n.between?(0,7) }
        @m_children.push(child) if [0,1].include?(i) 
        @c_children.push(child) if [2,3].include?(i) 
      elsif child.all? { |n| n.between?(0,7) } 
        @m_children.push(child) if i == 0
        @c_children.push(child) if i != 0
      end
    end
  end

  def inverse_moves(set)
    set.each do |m|
      m.map! do |i|
        i *= -1
      end
    end
  end
end