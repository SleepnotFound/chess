require_relative 'board'
require_relative 'player'
require_relative 'pieces'
require_relative 'load_save'
require 'yaml'

class Game 
  include Pieces

  attr_accessor :board, :player1, :player2, :active_player
  
  def initialize
    @player1 = Player.new('white', white)
    @player2 = Player.new('black', black)
    @board = Board.new(@player1.pieces, @player2.pieces)
    @active_player = self.player1
  end

  def play
    set_game
    self.board.build_board(player1.pieces, player2.pieces)
    player_turn
    #save_game(to_yaml)
  end

  def to_yaml
    YAML.dump({
      player1: @player1,
      player2: @player2,
      active_player: @active_player
    })
  end

  def player_turn
    selected = select_piece
    puts "selected object: #{selected.piece}\navailable spots to move in:"
     #the line underneath can be deleted as long as ALL pieces have children
    selected.make_children if selected.children.empty?
    selected.children.each do |child|
      puts convert_to_board_cords(child)
    end
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

  def set_game
    mode = verify_mode
    if mode == '0'
      #display instructions/controls then jump to newgame
    elsif mode == '1'
      #load game
      data = load_game
      self.player1 = data[:player1]
      self.player2 = data[:player2]
      self.active_player = data[:active_player]
    elsif mode == '2'
      #new human vs computer
    end
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

  def verify_mode
    mode = get_mode
    until %w[0 1 2].include?(mode)
      #system "clear"
      puts "wrong mode. try again"
      mode = get_mode
    end
    mode
  end

  private

  def get_input
    puts "#{active_player.name}, select a cell"
    gets.chomp
  end

  def get_mode
    puts "press:\n0) for instructions\n1) to load game\n2) for human vs computer"
    gets.chomp
  end
end