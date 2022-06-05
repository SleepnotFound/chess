require './lib/pawn'
require './lib/pieces'
include Pieces

describe Pawn do
  describe '#make_children' do
    context 'when white pawn starts first move at b2' do
      subject(:pawn_children) { described_class.new(white + pawn, [6,1]) }
      it 'makes 2 move children and 2 capture children' do
        move_set = [[5,1], [4,1]]
        capture_set = [[5,0], [5,2]]
        pawn_children.make_children
        c_children = pawn_children.c_children
        m_children = pawn_children.m_children
        expect(m_children.sort).to eq(move_set.sort)
        expect(c_children.sort).to eq(capture_set.sort)
      end
    end
    context 'when white pawn starts non-first move at h6' do
      subject(:pawn_children) { described_class.new(white + pawn, [2,7]) }
      before do
        pawn_children.instance_variable_set(:@on_first_move, false)
      end
      it 'makes 1 move children and 1 capture children' do
        move_set = [[1,7]]
        capture_set = [[1,6]]
        pawn_children.make_children
        c_children = pawn_children.c_children
        m_children = pawn_children.m_children
        expect(m_children.sort).to eq(move_set.sort)
        expect(c_children.sort).to eq(capture_set.sort)
      end
    end
    context 'when black pawn starts first move at a7' do
      subject(:pawn_children) { described_class.new(black + pawn, [1,0]) }
      it 'makes 2 move children and 1 capture children' do
        move_set = [[2,0],[3,0]]
        capture_set = [[2,1]]
        pawn_children.make_children
        c_children = pawn_children.c_children
        m_children = pawn_children.m_children
        expect(m_children.sort).to eq(move_set.sort)
        expect(c_children.sort).to eq(capture_set.sort)
      end
    end
  end
end