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
    loop do 
      threats = find_threats
      if threats.empty? && stalemate? 
        board.build_board
        puts "Stalemate!"
        break
      end
      forced_moveset = begin_with_moveset(threats)
      if forced_moveset.nil?
        board.build_board
        puts "checkmate!\nPlayer #{opponent.name} has won!"
        break
      end
      forced_moveset ? player_turn(forced_moveset) : player_turn
      self.active_player = active_player == player1 ? player2 : player1
    end
    puts "end of game"
  end
  
  def player_turn(forced_moveset = nil)
    loop do
      board.build_board
      puts "Player #{active_player.name}\'s turn"
      if forced_moveset 
        puts "\e[1mYou are in check!\e[0m"
        set = select_piece(forced_moveset)
        selected = set[0]
        selected_moveset = set[1]
      else
        selected = select_piece
        selected_moveset = move_checker(selected, active_player.pieces, opponent.pieces)
      end
      #puts "legal moves:#{selected_moveset} for position:#{selected.position}"
      board.visualize_moves(selected_moveset, selected.position)
      puts "selected piece: #{selected.piece + reset}\nType \'back\' to go back or"
      break if next_move(selected_moveset, selected)
    end
  end

  def get_player_input
    loop do
       verified_input = verify_input(get_input)
       return verified_input if verified_input 
    end
  end

  def opponent
    active_player == player1 ? player2 : player1
  end

  def select_piece(forced_moveset = nil)
    loop do
      case player_input = get_player_input
      when 'save'
        save_game(to_yaml)
      when 'back'
        puts "cannot go 'back' at the start of your turn!"
      else
        tile = convert_to_array_cords(player_input)
        if forced_moveset 
          selected = forced_moveset.find { |s| s[0].position == tile }
          return selected if selected
          puts "Invalid. Your king is in check!"
        else
          selected = self.active_player.pieces.find { |piece| piece.position == tile }
          return selected if selected
          puts "Could not find piece."
        end
      end
    end
  end

  def next_move(movements, selected)
    loop do
      case new_input = get_player_input
      when 'save'
        save_game(to_yaml)
      when 'back'
        return false
      else 
        new_tile = convert_to_array_cords(new_input)
        if movements[:legal_moves].include?(new_tile)
          selected.position = new_tile
          update_all_pieces
          if selected.type == 'pawn'
            selected.on_first_move = false
            selected.passant = true if movements[:legal_moves][1] == new_tile
          elsif selected.type == 'king' || selected.type == 'rook' 
            selected.on_first_move == false
          end
          return true
        elsif movements[:captures].include?(new_tile)
          capturing(selected, new_tile)
          update_all_pieces
          selected.on_first_move = false if ['pawn','king','rook'].include?(selected.type)
          return true
        else
          puts "invalid. move into a cyan dot or capture any green tile"
        end
      end
    end
  end

  def update_all_pieces
    all_pieces = player1.pieces + player2.pieces
    occupied_tiles = []
    all_pieces.each { |p| occupied_tiles << p.position }
    all_pieces.each do |p|
      ['queen', 'rook', 'bishop'].include?(p.type) ? p.make_children(occupied_tiles) : p.make_children
      p.passant = false if p.type == 'pawn'
    end
  end

  def set_game
    #case mode = '1'
    case mode = verify_mode
    when '0'
      #display instructions/controls then jump to new game
    when '1'
      data = load_game
      self.player1 = data[:player1]
      self.player2 = data[:player2]
      self.active_player = data[:active_player]
    when '2'
      new_game
      update_all_pieces
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
    puts "press:\n0) for instructions\n1) to load game\n2) for new game"
    gets.chomp
  end
end