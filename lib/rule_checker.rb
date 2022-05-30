require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
  all_pieces = player_set + opponent_set

  case selected.type
  when 'king'
    illegal_moves = []
    capture_tiles = []
    player_set.each do |piece|
      common_tiles = selected.children & [piece.position]
      illegal_moves.push(common_tiles) unless common_tiles.empty?
    end
    opponent_set.each do |piece|
      common = selected.children & piece.children
      illegal_moves.push(common) unless common.empty?
      capture = selected.children & [piece.position]
      capture_tiles.push(capture) unless capture.empty?
      case piece.type
      when 'pawn'
        puts "pawn forward move: #{piece.children[0]}"
        illegal_moves.delete(piece.children[0])
      when 'queen', 'bishop', 'rook'
        if piece.children.include?(selected.position)
          retreat_tile = backtracking(selected.position, piece.position)
          illegal_moves.push([retreat_tile])
        end
      end
    end
    illegal_moves = illegal_moves.flatten(1).uniq unless illegal_moves.empty?
    capture_tiles = capture_tiles.flatten(1).uniq unless capture_tiles.empty?
    {legal_moves: selected.children - illegal_moves, captures: capture_tiles - illegal_moves}
  when 'queen', 'bishop', 'rook'
    occupied_tiles = []
    capture_tiles = []
    all_pieces.each { |p| occupied_tiles << p.position }
    contact_tiles = occupied_tiles & selected.children
    contact_tiles.each do |tile| 
      piece = all_pieces.find { |p| p.position == tile }
      if player_set.include?(piece)
        selected.children.delete(piece.position)
      else
        capture_tiles << piece.position
      end
    end
    {legal_moves: selected.children, captures: capture_tiles}
  when 'knight'
    # knight logic here
  else
    puts "type of selected piece was not found"
  end
end

def backtracking(selected, piece)
  a = selected[0] <=> piece[0]
  b = selected[1] <=> piece[1]
  [selected[0] + a, selected[1] + b]
end