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
end