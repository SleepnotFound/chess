require_relative 'pieces'
require_relative 'tile'


class Board 
  include Pieces

  def initialize 
    @board = Array.new(8) { Array.new(8) }
    build_board
  end

  def build_board
    @board.each_with_index do | row, r |
      row.each_with_index do | tile, t |
        if r.even? 
          #1st pattern
          tile = t.even? ? Tile.new('white') : Tile.new('black')
        elsif r.odd?
          #2nd pattern
          tile = t.odd? ? Tile.new('white') : Tile.new('black')
        end
      end
    end
  end

  def display_board
    @board.each do |row|
      puts row 
    end
  end

  def test
    p @board[0][0].class
  end
end