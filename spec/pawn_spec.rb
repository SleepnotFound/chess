require './lib/pawn'
require './lib/pieces'
include Pieces

describe Pawn do
  describe '#make_children' do
    context 'when white pawn starts first move at b2' do
      subject(:pawn_children) { described_class.new(white + pawn, [6,1]) }
      it 'makes 4 available children' do
        # possible 4 moves for pawn. which include diagonal captures
        correct_set = [[5,1], [4,1], [5,0], [5,2]]
        # method make_children is initialized when object is created and stored in @children
        pawn_children.make_children
        children = pawn_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
    context 'when white pawn starts non-first move at f6' do
      subject(:pawn_children) { described_class.new(white + pawn, [2,5]) }
      before do
        pawn_children.instance_variable_set(:@on_first_move, false)
      end
      it 'makes 3 available children' do
        #possible 3 moves including diagonal captures
        correct_set = [[1,4], [1,5], [1,6]]
        pawn_children.make_children
        children = pawn_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
    context 'when black pawn starts non-first move at d6' do
      subject(:pawn_children) { described_class.new(black + pawn, [2,3]) }
      before do
        pawn_children.instance_variable_set(:@on_first_move, false)
      end
      it 'makes 3 available children' do
        correct_set = [[3,2],[3,3],[3,4]]
        pawn_children.make_children
        children = pawn_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end