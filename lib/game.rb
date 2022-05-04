require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Game 
  include Pieces

  attr_accessor :board, :player1, :player2, :active_player
  
  def initialize
    @board = Board.new
    @player1 = Player.new(white)
    @player2 = Player.new(black)
    @active_player = self.player1
  end

  def play
    name_players
    set_game_pieces
    self.board.build_board
    player_turn
    #puts "#{active_player.name} available spots:"
    #valid_moves = active_player.pieces[0].children
    #valid_moves.each { |i| puts "#{i[0]}, #{i[1]}" }
  end

  def player_turn
    #input = convert_to_cords(verify_input)
    #p input
    #active_pieces = self.active_player.pieces
    selected = select_piece
    puts "selected object: #{selected} "
    p active_player
    #display_choices(selected)
  end

  def select_piece
    input = convert_to_cords(verify_input)
    until selected = self.active_player.pieces.find { |piece| piece.position == input }
      puts "no pieces found. please select another cell"
      input = convert_to_cords(verify_input)
    end
    selected
  end

  # y searches array in array. x searches cell in array(y) 
  def convert_to_cords(input)
    x = input[0].ord - 97
    y = 8 - input[1].to_i
    [y, x]
  end

  def get_input
    puts "#{active_player.name}, select a cell"
    gets.chomp
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

  def set_game_pieces
    #temp initialized pieces todo: set player pieces based on save file or default newgame
    t1 = King.new(white + king, [7,4])
    t3 = King.new(white + king, [3,3])
    t2 = King.new(black + king, [0,4])
    self.player1.pieces << t1
    self.player1.pieces << t3
    self.player2.pieces << t2
    self.board.white_pieces << self.player1.pieces[0]
    self.board.white_pieces << self.player1.pieces[1]
    self.board.black_pieces << self.player2.pieces[0]
  end

  def name_players
    @player1.name = set_names(1)
    @player2.name = set_names(2)
  end

  def set_names(id)
    puts "Player #{id}, what is you name?"
    gets.chomp
  end
end