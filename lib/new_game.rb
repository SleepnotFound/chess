require_relative 'king'
require_relative 'queen'
require_relative 'pawn'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'

def new_game
  8.times do |i|
    player1.pieces << Pawn.new(white + pawn, [6, i])
    player2.pieces << Pawn.new(black + pawn, [1, i])
    player1.pieces << set_pieces(white, 7, i)
    player2.pieces << set_pieces(black, 0, i)
  end
end

def set_pieces(color, row, i)
  set = [
        Rook.new(color + rook, [row, i]),
        Knight.new(color + knight, [row, i]),
        Bishop.new(color + bishop, [row, i]),
        Queen.new(color + queen, [row, i]),
        King.new(color + king, [row, i]),
        Bishop.new(color + bishop, [row, i]),
        Knight.new(color + knight, [row, i]),
        Rook.new(color + rook, [row, i])
        ]
  set[i]
end