require_relative 'tile'
require_relative 'king'
require_relative 'pieces'

class Board 
  include Pieces

  attr_reader :board, :black_pieces, :white_pieces
  #attr_accessor :board

  def initialize 
    @board = Array.new(8) { Array.new(8) }
    @white_pieces = []
    @black_pieces = []
    update_board
  end

  def build_board
    update_board
    display_board
  end

  def update_board
    @board.each_with_index do | row, r |
      row.each_with_index do | tile, t |
        if r.even? 
          @board[r][t] = t.even? ? Tile.new('white', insert_piece(r, t)) : Tile.new('black', insert_piece(r, t))
        elsif r.odd?
          @board[r][t] = t.odd? ? Tile.new('white', insert_piece(r, t)) : Tile.new('black', insert_piece(r, t))
        end
      end
    end
  end

  def insert_piece(y, x)
    self.white_pieces.each do |piece|
      return piece.piece if piece.position == [y, x]
    end
    self.black_pieces.each do |piece|
      return piece.piece if piece.position == [y, x]
    end
    blank_space
  end

  def display_board
    @board.each_with_index do |row, i|
      top = ' ' + join_row(row, 1)
      middle = "#{8 - i}" + join_row(row, 2)
      bottom = ' ' + join_row(row, 3)
      puts top + middle + bottom
    end
    puts '   a     b     c     d     e     f     g     h     '
  end

  def join_row(arr, row)
    str = ""
    case row
    when 1
      arr.each { |tile| str += tile.top }
    when 2
      arr.each { |tile| str += tile.middle }
    when 3
      arr.each { |tile| str += tile.bottom }
    end
    str += "\n"
  end

end