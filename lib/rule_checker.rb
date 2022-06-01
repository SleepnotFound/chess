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
    all_pieces.each { |p| illegal_moves += selected.children & [p.position] }
    opponent_set.each do |piece|
      illegal_moves += selected.children & piece.children
      capture_tiles += selected.children & [piece.position]
      case piece.type
      when 'pawn'
        moves = piece.on_first_move ? piece.children.take(2) : piece.children.take(1)
        moves.each do |m|
          i = illegal_moves.index(m)
          illegal_moves.delete_at(i) if i
        end
      when 'queen', 'bishop', 'rook'
        if piece.children.include?(selected.position)
          retreat_tile = backtracking(selected.position, piece.position)
          illegal_moves += [retreat_tile]
        end
      end
    end
    {legal_moves: selected.children - illegal_moves.uniq, captures: capture_tiles}
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
    if piece.passant
      y = piece.piece.include?(black) ? piece.position[0] - 1 : piece.position[0] + 1
      [[y, piece.position[1]]]
    else
      []
    end
  else 
    []
  end
end