require_relative 'pieces'

# A tile consists of 3 lines in the terminal

class Tile
  include Pieces

  attr_reader :top, :middle, :bottom, :piece

  def initialize(tile, piece = blank_space)
    @top = nil
    @middle = nil
    @bottom = nil
    @piece = piece
    build_tile(tile, piece)
  end

  def build_tile(tile, piece)
    @top    = row(tile, blank_space)
    @middle = row(tile,piece)
    @bottom = row(tile, blank_space)
  end

  def row(color, piece)
    "#{color}  #{piece}   \e[0m"
  end
end