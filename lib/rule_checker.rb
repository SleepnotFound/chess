require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
  all_pieces = player_set + opponent_set
  illegal_tiles = []
  capture_tiles = []

  case selected.type
  when 'pawn'
    moves = selected.m_children
    captures = selected.c_children
    all_pieces.each do |piece|
      common_tiles = moves & [piece.position]
      illegal_tiles += [moves[1]] if common_tiles.any? && selected.on_first_move
      illegal_tiles += common_tiles
      capture_tiles += captures & [piece.position] if opponent_set.include?(piece)
      capture_tiles += en_passant(selected,piece) if piece.type == 'pawn' && opponent_set.include?(piece)
    end
    {legal_moves: moves - illegal_tiles.uniq, captures: capture_tiles.uniq}
  when 'king'
    player_set.each { |p| illegal_tiles += selected.children & [p.position] }
    opponent_set.each do |piece|
      case piece.type
      when 'pawn'
        illegal_tiles += selected.children & piece.c_children
      when 'queen', 'bishop', 'rook'
        illegal_tiles += backtracking(selected.position, piece.position) if piece.children.include?(selected.position)
        illegal_tiles += selected.children & piece.children
      else
        illegal_tiles += selected.children & piece.children
      end
    end
    opponent_set.each do |piece|
      capture_tiles += selected.children & [piece.position] unless illegal_tiles.include?(piece.position)
    end
    {legal_moves: selected.children - illegal_tiles.uniq - capture_tiles, captures: capture_tiles}
  when 'queen', 'bishop', 'rook', 'knight'
    all_pieces.each do |piece|
      illegal_tiles += selected.children & [piece.position]
      capture_tiles += selected.children & [piece.position] if opponent_set.include?(piece)
    end
    {legal_moves: selected.children - illegal_tiles.uniq, captures: capture_tiles}
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
  puts "active: #{active_player.name}, opponent: #{opponent.name}"
  king = active_player.pieces.find { |p| p.type == 'king'}
  puts "king at #{king.position}"
  common = []
  piece = nil
  opponent.pieces.each do |p|
    common += p.children & [king.position]
  end
  p common
  return true if common.any?
end
