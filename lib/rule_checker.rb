require_relative 'pieces'
include Pieces

def move_checker(selected, player_set, opponent_set)
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
        #push only pawns 2 capture moves
      else
        common = selected.children & piece.children
        arr.push(common) unless common.empty?
      end
    end
    arr = arr.flatten(1).uniq unless arr.empty?
    selected.children - arr 
  when 'queen'
    arr = []
    player_set.each { |p| arr << p.position }
    opponent_set.each { |p| arr << p.position }
    legitimate_children(selected, arr)

    #arr = arr.flatten(1).uniq unless arr.empty?
    #selected.children - arr 

    selected.children
  else
    puts "type of selected piece was not found"
  end
end


# for queen,bishop,rook
def legitimate_children(selected, positions)
  selected.children = []
  selected.moves.each do |move|
    y = move[0]
    x = move[1]
    loop do
      child = [selected.position[0] + move[0], selected.position[1] + move[1]]
      move[0] += y
      move[1] += x
      #puts "a match was found #{child} vs #{position}" if child == position
      if child.all? { |n| n.between?(0, 7) }
        selected.children.push(child)
        break if positions.any? { |p| p == child }
      end
      break unless move.all? { |i| i.between?(-7,7) }
    end
  end
end



