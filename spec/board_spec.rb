require './lib/board'

describe Board do
  describe '#build_board' do
    subject(:make_board) { described_class.new }
    context 'when a board is initialized' do
      it 'all items should be a Tile class' do
        game = make_board
        results = []
        game.board.each do |row|
          a = row.all?(Tile)
          results << a
        end
        expect(results).to be_all(true)
      end
    end
  end

  describe '#join_row' do
    context 'when given an array and number' do
      it 'outputs '
    end
  end
end