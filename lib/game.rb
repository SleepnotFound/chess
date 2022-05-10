require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Game 
  include Pieces

  attr_accessor :board, :player1, :player2, :active_player
  
  def initialize
    @board = Board.new
    @player1 = Player.new('white', white)
    @player2 = Player.new('black', black)
    @active_player = self.player1
  end

  def play
    set_game_pieces
    self.board.build_board
    player_turn
  end

  def player_turn
    selected = select_piece
    puts "selected object: #{selected.piece}\navailable spots to move in:"
    selected.make_children
    selected.children.each do |child|
      puts convert_to_board_cords(child)
    end
    #puts "#{selected.children}"
  end

  def select_piece
    input = convert_to_array_cords(verify_input)
    until selected = self.active_player.pieces.find { |piece| piece.position == input }
      puts "no pieces found. please select another cell"
      input = convert_to_array_cords(verify_input)
    end
    selected
  end

  # y searches arrays in array. x searches cell in array(y) 
  def convert_to_array_cords(input)
    x = input[0].ord - 97
    y = 8 - input[1].to_i
    [y, x]
  end

  def convert_to_board_cords(input)
    x = 8 - input[0]
    y = (input[1] + 97).chr
    "#{y}#{x}"
  end

  def set_game_pieces
    #temp initialized pieces todo: set player pieces based on save file or default newgame
    t1 = King.new(white + king, [7,4])
    t3 = King.new(white + king, [0,3])
    t2 = King.new(black + king, [0,4])
    self.player1.pieces << t1
    self.player1.pieces << t3
    self.player2.pieces << t2
    self.board.white_pieces << self.player1.pieces[0]
    self.board.white_pieces << self.player1.pieces[1]
    self.board.black_pieces << self.player2.pieces[0]
  end

  def verify_input
    input = get_input.downcase
    until input.match?("\[a-h][1-8]") || input.match?("\[0-8][a-h]")
      puts 'wrong input. only (a-h)(1-8)'
      input = get_input.downcase
    end
    input = input[1] + input[0] if input.match?("\[0-8][a-h]")
    input
  end

  private

  def get_input
    puts "#{active_player.name}, select a cell"
    gets.chomp
  end
end