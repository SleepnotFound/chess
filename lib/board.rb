require_relative 'pieces'


class Board 
  include Pieces

  def initialize 
    @board = build_board
  end

  def build_board
    arr = Array.new(8) { Array.new(8) }
    arr.each_with_index do | row, r |
      row.each_with_index do | tile, t |
        if r.even? 
          #1st pattern
          t.even? ? arr[r][t] = build_tile('white') : arr[r][t] = build_tile('black')
        elsif r.odd?
          #2nd pattern
          t.odd? ? arr[r][t] = build_tile('white') : arr[r][t] = build_tile('black')
        end
      end
    end
  end

  def display_board
    @board.each do |row|
      puts row.reduce { |r, c| r + c }      
    end
  end
end