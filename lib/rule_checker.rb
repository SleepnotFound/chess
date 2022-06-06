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
  [[selected[0] + a, selected[1] + b]]
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
  king = active_player.pieces.find { |p| p.type == 'king' }
  threats = []
  opponent.pieces.each do |p|
    if p.type == 'pawn'
      threats << p if (p.c_children & [king.position]).any?
    else
      threats << p if (p.children & [king.position]).any?
    end
  end
  return false if threats.empty?
  threats
end

def find_forced_moveset(threats)
  puts "find_forced_moveset called.returning options"
  puts "# of threats: #{threats.length}"
  options = []
  king = active_player.pieces.find { |p| p.type == 'king' }
  puts "king:#{king.piece + reset}. pos:#{king.position}"
  king_moveset = move_checker(king, active_player.pieces, opponent.pieces)
  if threats.length > 1
    #return only king moveset
    options << [king, king_moveset]
  else
    #return king moveset,captures and block pieces, with their movesets
    threat = threats[0]
    #find intersection if exists else nil
    intersection = find_intersections(king, threat)
    puts "intersection:#{intersection}"
    options << [king, king_moveset]
    #todo: when intersection is nil just check for captures else check more blocks and captures
    active_player.pieces.each do |p|
      next if p.type == 'king'
      if p.type == 'pawn'
        if (p.m_children & intersection).any? || (p.c_children & threat.position).any?
          moveset = { legal_moves: [], captures: [] }
          moveset[:legal_moves] << intersection.flatten if (p.m_children & intersection).any?
          moveset[:captures] << threat.position if (p.c_children & threat.position).any?
          options << [p, moveset]
        end
      else
        if (p.children & intersection).any? || (p.children & threat.position).any?
          moveset = { legal_moves: [], captures: [] }
          moveset[:legal_moves] << intersection.flatten if (p.children & intersection).any?
          moveset[:captures] << threat.position if (p.children & threat.position).any?
          options << [p, moveset]
        end
      end
    end
  end
  options
end

def find_intersections(king, piece)
  if (king.children & [piece.position]).any?
    return nil
  else
    intersection = king.children & piece.children
    if intersection.length > 1 && piece.type == 'queen'
      puts "  finding middle child"
      intersection = [[(king.position[0] + piece.position[0])/2, (king.position[1] + piece.position[1])/2]]
    end
  end
end
