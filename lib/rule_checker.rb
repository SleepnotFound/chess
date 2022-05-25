require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
  all_pieces = player_set + opponent_set

  case selected.type
   #Ensures king does not move into check 
  when 'king'
    arr = []
    player_set.each do |piece|
      common = selected.children & [piece.position]
      arr.push(common) unless common.empty?
    end
    opponent_set.each do |piece|
      if piece.type == 'pawn'
        #push only pawns 2 diagonal capture moves
      else
        common = selected.children & piece.children
        arr.push(common) unless common.empty?
      end
    end
    arr = arr.flatten(1).uniq unless arr.empty?
    selected.children - arr 
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
    {legal_move: selected.children, captures: capture_points}
  else
    puts "type of selected piece was not found"
  end
end




