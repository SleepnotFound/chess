require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
  case selected.type
   #Ensures king does not move into check 
  when 'king'
    arr = []
    player_set.each do |piece|
      p "#{selected.children} vs #{piece.position}"
      common = selected.children & [piece.position]
      arr.push(common) unless common.empty?
    end
    p arr
    opponent_set.each do |piece|
      if piece.type == 'pawn'
        #push only pawns 2 capture moves
      else
        common = selected.children & piece.children
        arr.push(common) unless common.empty?
      end
    end
    arr = arr.flatten(1).uniq unless arr.empty?
    selected.children - arr 
  else
    puts "type of selected piece was not found"
  end
end

