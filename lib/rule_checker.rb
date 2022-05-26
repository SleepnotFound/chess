require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
  all_pieces = player_set + opponent_set

  case selected.type
  when 'king'
    illegal_moves = []
    capture_points = []
    player_set.each do |piece|
      common = selected.children & [piece.position]
      illegal_moves.push(common) unless common.empty?
    end
    opponent_set.each do |piece|
      if piece.type == 'pawn'
        #push only pawns 2 diagonal capture moves
      elsif piece.type == 'queen'
        back_track = backtracking(selected.position, piece.position)
        illegal_moves.push([back_track])
      end
      common = selected.children & piece.children
      illegal_moves.push(common) unless common.empty?

      capture = selected.children & [piece.position]
      capture_points.push(capture) unless capture.empty?
    end
    illegal_moves = illegal_moves.flatten(1).uniq unless illegal_moves.empty?
    capture_points = capture_points.flatten(1).uniq unless capture_points.empty?
    {legal_moves: selected.children - illegal_moves, captures: capture_points}
  when 'queen'
    occupied_tiles = []
    all_pieces.each { |p| occupied_tiles << p.position }
    selected.make_children(occupied_tiles)
    
    common = occupied_tiles & selected.children
    capture_points = []
    common.each do |tile| 
      piece = all_pieces.find { |p| p.position == tile }
      if player_set.include?(piece)
        selected.children.delete(piece.position)
      else
        capture_points << piece.position
      end
    end
    {legal_moves: selected.children, captures: capture_points}
  else
    puts "type of selected piece was not found"
  end
end

def backtracking(selected, piece)
  a = selected[0] <=> piece[0]
  b = selected[1] <=> piece[1]
  [selected[0] + a, selected[1] + b]
end




