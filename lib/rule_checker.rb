require_relative 'pieces'
include Pieces

def rule_checker(selected, opponent_set)
  case selected.type
  when 'king'
    arr = []
    p selected.children
    opponent_set.each do |piece|
      p piece.children
      common = selected.children & piece.children
      p "common: #{common}"
      arr.push(common) unless common.empty?
    end
    p arr.flatten!(1).uniq!
  else
    puts "type of selected piece was not found"
  end
end