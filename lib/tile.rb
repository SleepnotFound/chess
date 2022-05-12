require_relative 'pieces'

# A tile consists of 3 lines in the terminal

class Tile
  include Pieces

  attr_reader :buffer, :middle, :piece, :color

  def initialize(tile_color, piece = blank_space)
    @piece = piece
    @color = tile_color
    @buffer = "#{self.color}  #{blank_space}   \e[0m"
    @middle = "#{self.color}  #{self.piece}   \e[0m"
  end

  def row(color, piece)
    "#{color}  #{piece}   \e[0m"
  end

  def piece=(piece)
    @piece = piece
    @middle = "#{color}  #{piece}   \e[0m"
  end

  def color=(color)
    @color = color
    @buffer = "#{color}  #{blank_space}   \e[0m"
    @middle = "#{color}  #{piece}   \e[0m"
  end

end