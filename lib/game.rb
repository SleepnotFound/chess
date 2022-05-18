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
    game_over = false
    until game_over
      player_turn
      self.active_player = active_player == player1 ? player2 : player1
    end
    #save_game(to_yaml)
  end

  def player_turn
    opponent = active_player == player1 ? player2 : player1
    loop do
      board.build_board
      puts "Player #{active_player.name}\'s turn"
      selected_piece = nil

      loop do
        case player_input = get_player_input
        when 'save'
          save_game(to_yaml)
        when 'back'
          puts "cannot go 'back' at the start of your turn!"
        else
          tile = convert_to_array_cords(player_input)
          if selected = self.active_player.pieces.find { |piece| piece.position == tile }
            selected_piece = selected
            break
          else
            puts "could not find piece. Please select another tile."
          end
        end
      end

      
      legal_moves = move_checker(selected_piece, opponent.pieces)
      board.visualize_moves(legal_moves, selected_piece.position)
      puts "selected piece: #{selected_piece.piece + reset}\nType \'back\' to go back or"

      #new_move = get_player_choice(legal_moves)
      loop do
        case new_input = get_player_input
        when 'save'
          save_game(to_yaml)
        when 'back'
          break
        else 
          new_tile = convert_to_array_cords(new_input)
          if legal_moves.include?(new_tile)
            selected_piece.update(new_tile)
            break
          else
            puts "not valid. Choose a tile with a cyan dot."
          end
        end
      end
    end
  end

  def get_player_input
    loop do
       verified_input = verify_input(get_input)
       return verified_input if verified_input 
    end
  end

  def find_piece(input)
    until selected = self.active_player.pieces.find { |piece| piece.position == input }
      puts "no pieces found. please select another cell"
      input = convert_to_array_cords(get_player_input)
    end
    selected
  end

  def get_player_choice(movements)
    more_options = ['back', 'save']
    choices = movements + more_options
    loop do
      input = get_input
      input = convert_to_array_cords(verify_input(input)) unless more_options.include?(input) || verify_input(input).nil?
      return input if choices.include?(input)
      puts 'not valid. choose a tile with a cyan dot.'
    end
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
    commands = ['save', 'back']
    if input.match?(/\b[a-h][1-8]\b|\b[0-8][a-h]\b/) || commands.include?(input)
      input = input[1] + input[0] if input.match?(/\b[0-8][a-h]\b/)
      input
    else
      puts 'wrong input. only (a-h)(1-8)'
      nil
    end
  end

  def verify_mode
    mode = get_mode
    until %w[0 1 2].include?(mode)
      puts "wrong mode. try again"
      mode = get_mode
    end
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