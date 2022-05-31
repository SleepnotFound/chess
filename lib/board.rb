require_relative 'tile'
require_relative 'king'
require_relative 'pieces'

class Board 
  include Pieces

  attr_reader :board
  attr_accessor :black_pieces, :white_pieces

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @white_pieces = nil
    @black_pieces = nil
  end

  def build_board
    update_board
    display_board
  end

  def update_pieces(set_1, set_2)
    self.white_pieces = set_1
    self.black_pieces = set_2
  end

  def update_board
    @board.each_with_index do | row, r |
      row.each_with_index do | tile, t |
        if r.even? 
          @board[r][t] = t.even? ? Tile.new(tile_white, insert_piece(r, t)) : Tile.new(tile_black, insert_piece(r, t))
        elsif r.odd?
          @board[r][t] = t.odd? ? Tile.new(tile_white, insert_piece(r, t)) : Tile.new(tile_black, insert_piece(r, t))
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
      arr.each { |tile| str += tile.buffer }
    when 2
      arr.each { |tile| str += tile.middle }
    when 3
      arr.each { |tile| str += tile.buffer }
    end
    str += "\n"
  end

  def visualize_moves(legal_moves, position)
    original = board

    board[position[0]][position[1]].color = b_cyan
    legal_moves[:legal_moves].each do |t|
      board[t[0]][t[1]].piece = cyan + circle
    end
    legal_moves[:captures].each do |c|
      board[c[0]][c[1]].color = b_green
    end
    display_board
    @board = original
  end

end