require './lib/knight'
require './lib/pieces'
include Pieces

describe Knight do
  describe '#make_children' do
    context 'when the starting position is a6' do
      subject(:knight_children) { described_class.new(black + rook, [2,0]) }
      it 'makes 4 available children' do
        correct_set = []
        # knight 4 possible moves from b6
        correct_set << [0,1]
        correct_set << [1,2]
        correct_set << [3,2]
        correct_set << [4,1]
        # method make_children is initialized when object is created and stored in @children
        children = knight_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end