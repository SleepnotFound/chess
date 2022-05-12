require './lib/king'
require './lib/pieces'
include Pieces

describe King do
  describe '#make_children' do
    context 'when the starting position is [4,7]' do
      subject(:king_children) { described_class.new(black + king, [4,7]) }
      it 'makes 5 available children' do
        correct_set = [[5,7], [5,6], [4,6], [3,6], [3,7]]
        king_children.make_children
        children = king_children.children
        expect(children).to eq(correct_set)
      end
    end
  end
end