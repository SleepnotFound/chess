require_relative 'pieces'
include Pieces

def rule_checker(selected, opponent_set)
  case selected.type
   #Ensures king does not move into check 
  when 'king'
    arr = []
    opponent_set.each do |piece|
      common = selected.children & piece.children
      arr.push(common) unless common.empty?
    end
    arr = arr.flatten(1).uniq unless arr.empty?
    selected.children - arr 
  else
    puts "type of selected piece was not found"
  end
end