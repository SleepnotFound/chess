require_relative 'pieces'
require_relative 'rule_checker'

class King 
  include Pieces

  attr_reader :position, :piece, :children

  MOVES = [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]].freeze

  def initialize(piece, position)
    @piece = piece
    @position = position
    @children = []
    make_children if @children.empty?
  end

  def make_children
    King::MOVES.each do |move|
      child = [position[0] + move[0], position[1] + move[1]]
      if child.all? { |n| n.between?(0, 7) }
        #logic code here. where to move king without being in check
        @children.push(child) if check_king_movement(child)
      end
    end
  end
end