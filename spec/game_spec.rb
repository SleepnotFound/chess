require './lib/game'

describe Game do
  describe '#verify_input' do
    subject(:game_verify) { described_class.new }
    context 'when method receives a1' do
      it 'returns a1' do
        input = 'a1'
        result = game_verify.verify_input(input)
        expect(result).to eq('a1')
      end
    end
    context 'when method receives 8d' do
      it "returns d8" do
        input = '8d'
        result = game_verify.verify_input(input)
        expect(result).to eq('d8')
      end
    end
    context 'when method receives 44aaa' do
      it 'returns nil' do
        input = '44aaa'
        expect(game_verify).to receive(:puts).with('wrong input. only (a-h)(1-8)')
        result = game_verify.verify_input(input)
        expect(result).to eq(nil)
      end
    end
  end

  describe '#verify_mode' do
    subject (:game_mode) { described_class.new }
    context 'when user inputs 5 then 1' do
      before do
        invalid = '5'
        valid = '1'
        allow(game_mode).to receive(:get_mode).and_return(invalid, valid)
      end
      it 'displays error message once' do
        error_message = 'wrong mode. try again'
        expect(game_mode).to receive(:puts).with(error_message).once
        game_mode.verify_mode
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
      let(:king_piece) { double('King', type: 'king', position: [7,4]) }
      let(:active_player) { double('player', pieces: [king_piece]) }
      context 'then chooses empty cell,cell with non-player piece ,then a cell with white piece' do
        before do
          second_try = "e8"
          third_try = "e1"
          game_select.instance_variable_set(:@active_player, active_player)
          allow(game_select).to receive(:player_input).and_return(second_try, third_try)
        end
        it 'outputs error message twice' do
          first_try = "a8"
          error_message = "no pieces found. please select another cell"
          expect(game_select).to receive(:puts).with(error_message).twice
          game_select.select_piece(first_try)
        end
      end
    end
  end

  describe '#get_player_choice' do
    subject(:game_options) { described_class.new }
    context 'when user inputs \'back\'' do
      it 'returns the string \'back\'' do
        allow(game_options).to receive(:get_input).and_return('back')
        movements = [[0,5],[1,5]]
        result = game_options.get_player_choice(movements)
        expect(result).to eq('back')
      end
    end
    context 'when user inputs a legal move from array movements' do
      it 'returns the array element' do
        allow(game_options).to receive(:get_input).and_return('f7')
        movements = [[0,5],[1,5]]
        result = game_options.get_player_choice(movements)
        expect(result).to eq([1,5])
      end
    end
    context 'when user inputs an illegal move' do
      it 'outputs error message once' do
        allow(game_options).to receive(:get_input).and_return('f1', 'f8')
        error_message = 'not valid. choose a tile with a cyan dot.'
        movements = [[0,5],[1,5]]
        expect(game_options).to receive(:puts).with(error_message).once
        game_options.get_player_choice(movements)
      end
    end
  end
end