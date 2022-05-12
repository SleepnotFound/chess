require './lib/tile'
require './lib/pieces'

include Pieces

describe Tile do 
  describe '#build_tile' do
    context 'when initialized with argument white' do
      subject(:white_tile) { described_class.new(tile_white) }
      it 'creates a blank white tile object' do
        tile = white_tile
        expect(tile.top).to eq("\e[47m  #{blank_space}   \e[0m")
        expect(tile.middle).to eq("\e[47m  #{blank_space}   \e[0m")
        expect(tile.bottom).to eq("\e[47m  #{blank_space}   \e[0m")
      end
    end
    context 'when initialized with argument black and white king' do
      subject(:black_tile) { described_class.new(tile_black, white + king)}
      it 'creates a black tile with a white king' do
        tile = black_tile
        expect(tile.top).to eq("\e[100m  #{blank_space}   \e[0m")
        expect(tile.middle).to eq("\e[100m  #{white + king}   \e[0m")
        expect(tile.bottom).to eq("\e[100m  #{blank_space}   \e[0m")
      end
    end
  end
end