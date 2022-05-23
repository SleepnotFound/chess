require './lib/bishop'
require './lib/pieces'
include Pieces

describe Bishop do
  describe '#make_children' do
    context 'when the starting position is d8' do
      subject(:bishop_children) { described_class.new(black + bishop, [0,3]) }
      it 'makes 7 available children' do
        correct_set = []
        # bishop possible moves in 2 directions from d8
        1.upto(3) { |i| correct_set << [i, 3 - i] }
        1.upto(4) { |i| correct_set << [i, 3 + i] }
        # method make_children is initialized when object is created and stored in @children
        children = bishop_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end