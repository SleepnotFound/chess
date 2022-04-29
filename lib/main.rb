require_relative 'pieces'
require_relative 'board'

include Pieces

#8.times { |i| i.even? ? build_black_tile(blank_space) : build_white_tile(blank_space) }

puts black_king
puts white_king

puts 'call empty white tile'
puts build_tile('white')
puts 'call empty black tile'
puts build_tile('black')
puts 'call black king in both tiles'
puts build_tile('white', black_king) + build_tile('black', black_king)
puts 'call white king in both tiles'
puts build_tile('white', white_king) + build_tile('black', white_king)