require './lib/game'

describe Game do
  describe '#verify_input' do
    subject(:game_verify) { described_class.new }
    context 'when user inputs A1' do
      it 'returns input as a1' do
        input = 'A1'
        allow(game_verify).to receive(:get_input).and_return(input)
        result = game_verify.verify_input
        expect(result).to eq('a1')
      end
    end

    context 'when user inputs 8D' do
      it "returns input as d8" do
        input = '8D'
        allow(game_verify).to receive(:get_input).and_return(input)
        result = game_verify.verify_input
        expect(result).to eq('d8')
      end
    end
  end

  describe '#convert_to_array_cords' do
    subject(:game_convert) { described_class.new }
    context 'when input is e8' do
      it 'outputs [0,4]' do
        input = 'e8'
        result = game_convert.convert_to_array_cords(input)
        expect(result).to eq([0,4])
      end
    end
  end

  describe '#convert_to_board_cords' do
    subject(:game_convert) { described_class.new }
    context 'when given [4,4]' do
      it 'outputs e4' do
        input = [4,4]
        result = game_convert.convert_to_board_cords(input)
        expect(result).to eq('e4')
      end
    end
  end

  describe '#select_piece' do
    subject(:game_select) { described_class.new }
    context 'when its active player\'s(white) turn to pick a piece on board' do
      context 'then chooses empty cell,cell with black piece ,then a cell with white piece' do
        before do
          empty_cell = "a8"
          invalid_cell = "e8"
          valid_cell = "e1"
          allow(game_select).to receive(:get_input).and_return(empty_cell, invalid_cell, valid_cell)

        end
        it 'outputs error message twice' do
          error_message = "no pieces found. please select another cell"
          expect(game_select).to receive(:puts).with(error_message).twice
          game_select.set_game_pieces
          game_select.select_piece
        end
      end
    end
  end
end