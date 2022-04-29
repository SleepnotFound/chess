require_relative 'pieces'

class Tile
  include Pieces

  attr_reader :top, :middle, :bottom

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

  def black_row(piece)
    "\e[100m  #{piece}   \e[0m" 
  end
  
  def white_row(piece)
    "\e[47m  #{piece}   \e[0m" 
  end

  def show
     puts @top
     puts @middle
     puts @bottom
  end
end