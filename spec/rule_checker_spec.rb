require './lib/rule_checker'
require './lib/pieces'
include Pieces

describe '#backtracting' do
  context 'if king is in check by queen/bishop/rook. find tile behind king.' do
    context 'when king is at b8 and opponent queen is at d8' do
      let(:king) { double('King', position: [0,1]) }
      let(:queen) { double('Queen', position: [0,3]) }
      it 'returns tile a8' do
        king_pos = king.position
        queen_pos = queen.position
        correct_tile = [0,0]
        result = backtracking(king_pos, queen_pos)
        expect(result).to eq(correct_tile)
      end
    end
  end
end

describe '#en_passant' do
  context 'when white pawn is at c5' do
    let(:white_pawn) { double('Pawn', position: [3,2], passant: false) }
    let(:black_pawn) { double('Pawn', position: [3,3], passant: true) }
    context 'and black pawn\'s previous move was d7 to d5(en passant)' do
      it 'returns an array with that pawns position' do
        result = en_passant(white_pawn, black_pawn)
        expect(result).to eq([black_pawn.position])
      end
    end
    context 'and black pawn\'s previous move was d6 to d5(regular jump)' do
      let(:black_pawn) { double('Pawn', position: [3,3], passant: false) }
      it 'returns an empty array' do
        result = en_passant(white_pawn, black_pawn)
        expect(result).to eq([])
      end
    end
  end
end