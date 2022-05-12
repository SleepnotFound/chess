require './lib/board'
require './lib/pieces'
include Pieces

describe Board do
  describe '#build_board' do
    subject(:make_board) { described_class.new }
    context 'when build_board is called' do
      before do
        make_board.instance_variable_set(:@black_pieces, [])
        make_board.instance_variable_set(:@white_pieces, [])
      end
      it 'all items inside nested array should be a Tile class' do
        game = make_board
        game.update_board
        results = []
        game.board.each do |row|
          a = row.all?(Tile)
          results << a
        end
        expect(results).to be_all(true)
      end
    end
  end

  describe '#insert_piece' do
    subject(:piece_location) { described_class.new }
    context 'when board has no pieces in any location' do
      before do
        piece_location.instance_variable_set(:@black_pieces, [])
        piece_location.instance_variable_set(:@white_pieces, [])
      end
      it 'returns a blank space' do
        board_x_location = 0..7
        board_y_location = 0..7
        result = piece_location.insert_piece(board_x_location, board_y_location)
        expect(result).to eq(blank_space)
      end
    end
    context 'when a black_king is present at location 4,0' do
      let(:b_king) { double('king', position: [4,0], piece: black + king) }
      before do
        piece_location.instance_variable_set(:@black_pieces, [b_king])
        piece_location.instance_variable_set(:@white_pieces, [])
      end
      it 'returns that piece\'s string ' do
        board_x_location = 4
        board_y_location = 0
        result = piece_location.insert_piece(board_x_location, board_y_location)
        expect(result).to eq(b_king.piece)
      end
    end
  end
end