require_relative 'pieces'

class Tile
  include Pieces

  def initialize(tile, piece = blank_space)
    @top = nil
    @middle = nil
    @bottom = nil
    build_tile(tile, piece)
  end

  def build_tile(tile, piece)
    if tile == 'white'
      @top = white_row(blank_space)
      @middle = white_row(piece)
      @bottom = white_row(blank_space)
    elsif tile == 'black'
      @top = black_row(blank_space)
      @middle = black_row(piece)
      @bottom = black_row(blank_space)
    end
  end

  def show
     puts @top
     puts @middle
     puts @bottom
  end
end