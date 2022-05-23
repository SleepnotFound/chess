require './lib/rook'
require './lib/pieces'
include Pieces

describe Rook do
  describe '#make_children' do
    context 'when the starting position is d4' do
      subject(:rook_children) { described_class.new(black + rook, [4,3]) }
      it 'makes 14 available children' do
        correct_set = []
        # rook possible moves in 4 directions from d4
        0.upto(7) { |i| correct_set << [4, i] }
        0.upto(7) { |i| correct_set << [i, 3] }
        correct_set.delete([4, 3])
        # method make_children is initialized when object is created and stored in @children
        children = rook_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end