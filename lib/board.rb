require_relative 'tile'


class Board 

  attr_reader :board

  def initialize 
    @board = Array.new(8) { Array.new(8) }
    build_board
  end

  def build_board
    @board.each_with_index do | row, r |
      row.each_with_index do | tile, t |
        if r.even? 
          @board[r][t] = t.even? ? Tile.new('white') : Tile.new('black')
        elsif r.odd?
          @board[r][t] = t.odd? ? Tile.new('white') : Tile.new('black')
        end
      end
    end
  end

  def display_board
    @board.each do |row|
      top = join_row(row, 1)
      middle = join_row(row, 2)
      bottom = join_row(row, 3)
      puts top + middle + bottom
    end
  end

  def join_row(arr, num)
    row = ""
    case num
    when 1
      arr.each { |tile| row += tile.top }
    when 2
      arr.each { |tile| row += tile.middle }
    when 3
      arr.each { |tile| row += tile.bottom }
    end
    row += "\n"
  end

end