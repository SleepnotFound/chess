require_relative 'pieces'
include Pieces

# resposible for determining available actions of selected piece
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

# returns the tile behind selected. prevents moving back into check
def backtracking(selected, piece)
  a = selected[0] <=> piece[0]
  b = selected[1] <=> piece[1]
  [[selected[0] + a, selected[1] + b]]
end

# checks for passing pawns and returns adjacent pawns
def en_passant(selected, piece)
  left  = [selected.position[0], selected.position[1] - 1]
  right = [selected.position[0], selected.position[1] + 1]
  overlap = [left, right] & [piece.position]
  return overlap if overlap.any? && piece.passant
  
  []
end

# replace capture target with selected, including en passant pawns
def capturing(selected, new_tile)
  piece = opponent.pieces.find { |piece| piece.position == new_tile }
  opponent.pieces -= [piece]
  if selected.type == 'pawn' && piece.type == 'pawn' && (en_passant(selected, piece)).any?
    y = piece.piece.include?(black) ? piece.position[0] - 1 : piece.position[0] + 1
    selected.position = [y, piece.position[1]]
  else
    selected.position = new_tile
  end
  board.update_pieces(player1.pieces, player2.pieces)
end

# find if king is in check by 1 or multiple pieces
def find_threats
  king = find_king
  threats = []
  opponent.pieces.each do |p|
    if p.type == 'pawn'
      threats << p if (p.c_children & [king.position]).any?
    else
      threats << p if (p.children & [king.position]).any?
    end
  end
  threats
end

def find_king
  active_player.pieces.find { |p| p.type == 'king' }
end

# returns options to get out of check via moving\blocking\captures
def find_forced_moveset(threats)
  options = []
  king = find_king
  k_moveset = move_checker(king, active_player.pieces, opponent.pieces)
  options << [king, k_moveset] unless k_moveset[:legal_moves].empty? && k_moveset[:captures].empty?
  return options if threats.length > 1

  threat = threats[0]
  interceptions = find_interceptions(king, threat)
  active_player.pieces.each do |p|
    next if p.type == 'king'

    if p.type == 'pawn'
      blocks = p.m_children & interceptions
      captures = p.c_children & [threat.position]
    else
      blocks = p.children & interceptions
      captures = p.children & [threat.position]
    end
    if blocks.any? || captures.any?
      moveset = { legal_moves: [], captures: [] }
      moveset[:legal_moves] = blocks if blocks.any?
      moveset[:captures] << threat.position if captures.any?
      options << [p, moveset]
    end
  end
  options
end

# returns spots where a piece can block its king from check, if any
def find_interceptions(king, piece)
  interceptions = []
  return interceptions if ['pawn','knight'].include?(piece.type)
  
  dir = direction(king.position, piece.position)
  y = king.position[0]
  x = king.position[1]
  until [y += dir[0], x += dir[1]] == piece.position
    interceptions << [y, x]
  end
  interceptions
end

def direction(king, piece)
  a = piece[0] <=> king[0]
  b = piece[1] <=> king[1]
  [a, b]
end

# determines if player round should start with a forced moveset
def begin_with_moveset(threats)
  if threats.any?
    forced_moveset = find_forced_moveset(threats)
    return nil if forced_moveset.length == 0

    forced_moveset
  else
    false
  end
end

# determines if all pieces can no longer move, return true
def stalemate?
  active_player.pieces.each do |p|
    moves = move_checker(p, active_player.pieces, opponent.pieces)
    if moves[:legal_moves].any? || moves[:captures].any?
      return false
    end
  end
  true
end

# for pawns. decides if pawn reached furthest rank
def promote?(piece)
  last_rank = piece.piece.include?(white) ? 0 : 7
  return true if piece.position[0] == last_rank
  
  false
end

def promote(selected)
  color = selected.piece.include?(white) ? white : black
  pos = selected.position
  choice = get_promotion
  set = [
        Queen.new(color + queen, pos), 
        Rook.new(color + rook, pos),
        Bishop.new(color + bishop, pos),
        Knight.new(color + knight, pos)
        ]

  new_piece = set[choice - 1]
  active_player.pieces -= [selected]
  active_player.pieces += [new_piece]
  board.update_pieces(player1.pieces, player2.pieces)
end
