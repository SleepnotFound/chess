require './lib/bishop'
require './lib/pieces'
include Pieces

describe Bishop do
  describe '#make_children' do
    context 'when bishop position is d8 with no other pieces along its path' do
      subject(:bishop_children) { described_class.new(black + bishop, [0,3]) }
      it 'makes 7 available children' do
        out_ranged_piece = [1,3]
        occupied_spaces = [out_ranged_piece]
        correct_set = []
        1.upto(3) { |i| correct_set << [i, 3 - i] }
        1.upto(4) { |i| correct_set << [i, 3 + i] }
        bishop_children.make_children(occupied_spaces)
        children = bishop_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
    context 'when bishop position is b2 and another piece exists at d4' do
      subject(:bishop_children) { described_class.new(white + bishop, [6,1]) }
      it 'makes 5 available children' do
        d4_piece_pos = [4,3]
        occupied_spaces = [d4_piece_pos]
        correct_set = [[7,0],[7,2],[5,0],[5,2],[4,3]]
        bishop_children.make_children(occupied_spaces)
        expect(bishop_children.children.sort).to eq(correct_set.sort)
      end
    end
  end
end