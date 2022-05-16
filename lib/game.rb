require_relative 'board'
require_relative 'player'
require_relative 'pieces'
require_relative 'load_save'
require_relative 'rule_checker'
require 'yaml'

class Game 
  include Pieces

  attr_accessor :board, :player1, :player2, :active_player
  
  def initialize
    @player1 = Player.new('white', white)
    @player2 = Player.new('black', black)
    @board = Board.new
    @active_player = self.player1
  end

  def play
    set_game
    board.update_pieces(player1.pieces, player2.pieces)
    board.build_board
    game_over = false
    until game_over
      player_turn
      self.active_player = active_player == player1 ? player2 : player1
    end
    #save_game(to_yaml)
  end

  def player_turn
    puts "Player #{active_player.name}\'s turn"
    selected = select_piece(get_input)
    #system 'clear'
    opponent = active_player == player1 ? player2 : player1
    legal_moves = move_checker(selected, opponent.pieces)
    board.visualize_moves(legal_moves, selected.position)
    puts "selected piece: #{selected.piece + reset}\nType \'back\' to go back or"
    new_move = verify_legal_movement(legal_moves)
    selected.update(new_move)
    board.build_board
  end

  def select_piece(input)
    input = convert_to_array_cords(verify_input(input))
    until selected = self.active_player.pieces.find { |piece| piece.position == input }
      puts "no pieces found. please select another cell"
      input = convert_to_array_cords(verify_input(get_input))
    end
    selected
  end

  def verify_legal_movement(movements)
    input = get_input
    input = convert_to_array_cords(input)

    until movements.include?(input)
      puts 'Not valid. choose a tile with a cyan dot.'
      input = get_input
    end
    input
  end

  def set_game
    case mode = verify_mode
    when '0'
      #display instructions/controls then jump to new game
    when '1'
      data = load_game
      self.player1 = data[:player1]
      self.player2 = data[:player2]
      self.active_player = data[:active_player]
    when '2'
      #new human vs computer
    else
      puts "game could not set up..."
    end
    system 'clear'
  end

  def verify_input(input)
    until input.match?("\[a-h][1-8]") || input.match?("\[0-8][a-h]")
      puts 'wrong input. only (a-h)(1-8)'
      input = get_input
    end
    input = input[1] + input[0] if input.match?("\[0-8][a-h]")
    input
  end

  def verify_mode
    mode = get_mode
    until %w[0 1 2].include?(mode)
      puts "wrong mode. try again"
      mode = get_mode
    end
    system "clear"
    mode
  end

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

  def to_yaml
    YAML.dump({
      player1: @player1,
      player2: @player2,
      active_player: @active_player
    })
  end

  private

  def get_input
    puts "please select a tile"
    gets.chomp.downcase
  end

  def get_mode
    puts "press:\n0) for instructions\n1) to load game\n2) for human vs computer"
    gets.chomp
  end
end