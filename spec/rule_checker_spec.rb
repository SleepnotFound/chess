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
        correct_tile = [[0,0]]
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

describe '#find_interceptions' do
  context 'when white king is in check by opponent' do
    let(:white_king)  { double('king', position: [0,4], type: 'king') }
    let(:black_rook)  { double('rook', position: [0,0], type: 'rook') }
    let(:black_queen) { double('queen', position: [4,0], type: 'queen') }
    let(:black_knight) { double('knight', position: [1,2], type: 'knight') }
    context 'king is at e8 and black rook is at a8' do
      it 'returns an array with 3 elements of array coordinates' do
        correct_set = [[0,1],[0,2],[0,3]]
        result = find_interceptions(white_king, black_rook)
        expect(result.sort).to eq(correct_set.sort)
      end
    end
    context 'king is at e8 and black queen is at a4' do
      it 'returns an array with 3 elements of array coordinates' do
        correct_set = [[3,1],[2,2],[1,3]]
        result = find_interceptions(white_king, black_queen)
        expect(result.sort).to eq(correct_set.sort)
      end
    end
    context 'king is at e8 and black knight at c7' do
      it 'returns an empty array' do
        correct_set = []
        result = find_interceptions(white_king,black_knight)
        expect(result.sort).to eq(correct_set.sort)
      end
    end
  end
end