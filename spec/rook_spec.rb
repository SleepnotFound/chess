require './lib/rook'
require './lib/pieces'
include Pieces

describe Rook do
  describe '#make_children' do
    context 'when rook position is d4 and other piece is at h7' do
      subject(:rook_children) { described_class.new(black + rook, [4,3]) }
      it 'makes 14 available children' do
        other_piece_pos = [7, 7]
        occupied_spaces = [other_piece_pos]
        correct_set = []
        0.upto(7) { |i| correct_set << [4, i] }
        0.upto(7) { |i| correct_set << [i, 3] }
        correct_set.delete([4, 3])
        rook_children.make_children(occupied_spaces)
        children = rook_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
    context 'when rook position is d4 and 2 other pieces are at d3 & c4' do
      subject(:rook_children) { described_class.new(black + rook, [4,3]) }
      it 'makes 10 available children' do
        d3_piece_pos = [5, 3]
        c4_piece_pos = [4, 2]
        occupied_spaces = [d3_piece_pos, c4_piece_pos]
        correct_set = []
        2.upto(7) { |i| correct_set << [4, i] }
        0.upto(5) { |i| correct_set << [i, 3] }
        correct_set.delete([4, 3])
        rook_children.make_children(occupied_spaces)
        children = rook_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end