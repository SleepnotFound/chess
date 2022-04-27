require_relative 'pieces'
include Pieces

#8.times { |i| i.even? ? build_black_tile(blank_space) : build_white_tile(blank_space) }

build_w_tile(black_king)
build_b_tile(black_king)

build_w_tile(white_king)
build_b_tile(white_king)

puts black_king
puts white_king

