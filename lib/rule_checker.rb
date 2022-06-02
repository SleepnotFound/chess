require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
  all_pieces = player_set + opponent_set
  illegal_moves = []
  capture_tiles = []

  case selected.type
  when 'pawn'
    moves = selected.on_first_move ? selected.children.take(2) : selected.children.take(1)
    captures = selected.on_first_move ? selected.children.drop(2) : selected.children.drop(1)
    all_pieces.each do |piece|
      common_tiles = moves & [piece.position]
      illegal_moves += [moves[1]] if common_tiles.any? && selected.on_first_move
      illegal_moves += common_tiles
      capture_tiles += captures & [piece.position]
      capture_tiles += en_passant(selected,piece) if piece.type == 'pawn'
    end
    {legal_moves: moves - illegal_moves.uniq, captures: capture_tiles.uniq}
  when 'king'
    player_set.each { |p| illegal_moves += selected.children & [p.position] }
    retreat_tiles = []
    opponent_set.each do |piece|
      illegal_moves += selected.children & piece.children
      case piece.type
      when 'pawn'
        moves = piece.on_first_move ? piece.children.take(2) : piece.children.take(1)
        moves.each do |m|
          i = illegal_moves.index(m)
          illegal_moves.delete_at(i) if i
        end
      when 'queen', 'bishop', 'rook'
        if piece.children.include?(selected.position)
          retreat_tiles << backtracking(selected.position, piece.position)
        end
      end
    end
    opponent_set.each do |piece|
      capture_tiles += selected.children & [piece.position] unless illegal_moves.include?(piece.position)
    end
    capture_tiles -= retreat_tiles
    illegal_moves += retreat_tiles
    {legal_moves: selected.children - illegal_moves.uniq - capture_tiles, captures: capture_tiles}
  when 'queen', 'bishop', 'rook', 'knight'
    all_pieces.each do |piece|
      illegal_moves += selected.children & [piece.position]
      capture_tiles += selected.children & [piece.position] if opponent_set.include?(piece)
    end
    {legal_moves: selected.children - illegal_moves.uniq, captures: capture_tiles}
  end
end

# ensures king does not move back into check when checked by queen,bishop,rook
def backtracking(selected, piece)
  a = selected[0] <=> piece[0]
  b = selected[1] <=> piece[1]
  [selected[0] + a, selected[1] + b]
end

# checks for passing pawns and if eligible capture 
def en_passant(selected, piece)
  left  = [selected.position[0], selected.position[1] - 1]
  right = [selected.position[0], selected.position[1] + 1]
  overlap = [left, right] & [piece.position]
  if overlap.any? 
    return overlap if piece.passant
    []
  else 
    []
  end
end

# capture a piece,including pawn en passant logic
def capturing(selected, new_tile)
  opponent = active_player == player1 ? player2 : player1
  piece = opponent.pieces.find { |piece| piece.position == new_tile }
  opponent.pieces -= [piece]
  if selected.type == 'pawn' && piece.type == 'pawn' && piece.passant == true 
    y = piece.piece.include?(black) ? piece.position[0] - 1 : piece.position[0] + 1
    selected.position = [y, piece.position[1]]
  else
    selected.position = new_tile
  end
  board.update_pieces(player1.pieces, player2.pieces)
end

def in_check?
  opponent = active_player == player1 ? player2 : player1
  king = active_player.pieces.find { |p| p.type == 'king'}
  common = []
  opponent.pieces.each do |p|
    common += p.children & [king.position]
  end
  puts "king location:#{king.position}. common:#{common}"
  if common.any?
    move_set = move_checker(king, active_player.pieces, opponent.pieces)
    puts "moveset: #{move_set}"
  end
  return true if common.any?
end
