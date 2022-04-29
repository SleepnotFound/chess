require_relative 'pieces'
require_relative 'board'
require_relative 'tile'

include Pieces


puts black_king
puts white_king


w_tile = Tile.new('white')
b_tile = Tile.new('black')

w_tile.show
b_tile.show
bk_tile = Tile.new('white', black_king)
wk_tile = Tile.new('black', white_king)
bk_tile.show
wk_tile.show
#game = Board.new
#game.display_board