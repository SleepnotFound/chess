require_relative 'pieces'

class Queen 
  include Pieces

  attr_reader :position, :piece, :type, :children

  def initialize(piece, position)
    @piece = piece
    @position = position
    @type = 'queen'
    @children = []
  end

  def moves 
    [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  end

  def make_children(occupied_spaces)
    @children = []
    moves.each do |move|
      y = move[0]
      x = move[1]
      loop do
        child = [position[0] + move[0], position[1] + move[1]]
        move[0] += y
        move[1] += x
        if child.all? { |n| n.between?(0, 7) }
          @children.push(child)
          break if occupied_spaces.any? { |spaces| spaces == child }
        end
        break unless move.all? { |i| i.between?(-7,7) }
      end
    end
  end

  def update(position, occupied_spaces)
    @position = position
    make_children(occupied_spaces)
  end
end