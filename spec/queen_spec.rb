require './lib/queen'
require './lib/pieces'
include Pieces

describe Queen do
  describe '#make_children' do
    context 'when the starting position is a1' do
      subject(:queen_children) { described_class.new(black + queen, [7,0]) }
      it 'makes 21 available children' do
        correct_set = []
        # queen possible moves in 3 directions from a1
        6.downto(0) { |i| correct_set << [i,0] }
        1.upto(7) { |i| correct_set << [7, i] }
        1.upto(7) { |i| correct_set << [7 - i,i] }
        # Queen class initializes method #make_children and stores it in @children
        children = queen_children.children
        expect(children.sort).to eq(correct_set.sort)
      end
    end
  end
end