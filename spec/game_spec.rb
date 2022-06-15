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
    context 'when method receives \'save\'' do
      it 'returns the string \'save\'' do
        input = 'save'
        result = game_verify.verify_input(input)
        expect(result).to eq('save')
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
    context 'when selecting player white\'s king at e1 ' do
      let(:king_piece) { double('King', type: 'king', position: [7,4]) }
      let(:active_player) { double('player', pieces: [king_piece]) }
      context 'then player enters \'back\' then \'save\'' do
        before do
          game_select.instance_variable_set(:@active_player, active_player)
          allow(game_select).to receive(:get_player_input).and_return('back', 'save', 'e1')
          allow(game_select).to receive(:save_game)
        end
        it 'outputs error message once then calls method save_game' do
          error_message = 'cannot go \'back\' at the start of your turn!'
          expect(game_select).to receive(:puts).with(error_message).once
          expect(game_select).to receive(:save_game)
          game_select.select_piece
        end
      end
      context 'then player enters incorrect then correct location of piece' do
        before do
          incorrect_input = 'e6'
          correct_input = 'e1'
          game_select.instance_variable_set(:@active_player, active_player)
          allow(game_select).to receive(:get_player_input).and_return(incorrect_input, correct_input)
        end
        it 'outputs error message once then returns the players piece' do
          expect(game_select).to receive(:puts).with('Could not find piece.').once
          result = game_select.select_piece
          expect(result).to eq(king_piece)
        end
      end
    end
    context 'when player white\'s king at a1 is in check' do
      let(:king_piece) { double('King', type: 'king', position: [7,0]) }
      let(:active_player) { double('player', pieces: [king_piece]) }
      context 'then forced to select king at a1' do
        before do
          game_select.instance_variable_set(:@active_player, active_player)
          forced_input = 'a1'
          allow(game_select).to receive(:get_player_input).and_return(forced_input)
        end
        it 'outputs a size 2 array of the king object[0] and moveset[1]' do
          moveset = { legal_moves: [[7,1]], captures: [] }
          forced_moveset = [[king_piece, moveset]]
          result = game_select.select_piece(forced_moveset)
          expect(result).to eq(forced_moveset[0])
        end
      end
    end
  end

  describe '#next_move' do
    subject(:game_next_move) { described_class.new }
    let(:king_piece) { double('King', type: 'king', position: [7,4], on_first_move: true) }
    context 'when user inputs \'save\' and then \'back\'' do
      before do
        allow(game_next_move).to receive(:get_player_input).and_return('save', 'back')
        allow(game_next_move).to receive(:save_game)
      end
      it 'calls method save_game then returns false' do
        movements = [[6,4],[6,5]]
        expect(game_next_move).to receive(:save_game)
        result = game_next_move.next_move(movements, king_piece)
        expect(result).to be(false)
      end
    end
    context 'when user inputs a legal move from array movements' do
      before do
        input = 'e2'
        allow(game_next_move).to receive(:get_player_input).and_return(input)
        allow(king_piece).to receive(:position=)
      end
      it 'returns true and updates the array element' do
        movements = {:legal_moves=>[[7, 5], [7, 3], [6, 3], [6, 4], [6, 5]], :captures=>[]}
        result = game_next_move.next_move(movements, king_piece)
        expect(king_piece).to respond_to(:on_first_move)
        expect(result).to be(true)
      end
    end
  end
end