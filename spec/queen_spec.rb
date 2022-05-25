require './lib/queen'
require './lib/pieces'
include Pieces

describe Queen do
  describe '#make_children' do
    context 'when queen starting position is a1 and no other pieces exists' do
      subject(:queen_children) { described_class.new(black + queen, [7,0]) }
      it 'makes 21 available children' do
        correct_set = []
        occupied_spaces = []
        6.downto(0) { |i| correct_set << [i,0] }
        1.upto(7) { |i| correct_set << [7, i] }
        1.upto(7) { |i| correct_set << [7 - i,i] }
        queen_children.make_children(occupied_spaces)
        children = queen_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
    context 'when queen starts at h1 and another piece exist at d1 and c6' do
      subject(:queen_children) { described_class.new(white + queen, [7,7]) }
      it 'makes 16 available children' do
        d1_piece_pos = [7,3]
        c6_piece_pos = [2,2]
        occupied_spaces = [d1_piece_pos, c6_piece_pos]
        correct_set = []
        6.downto(0) { |i| correct_set << [i, 7] }
        3.upto(6) { |i| correct_set << [7, i] }
        6.downto(2) { |i| correct_set << [i, i] }
        queen_children.make_children(occupied_spaces)
        children = queen_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end