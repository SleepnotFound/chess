require_relative 'king'
require_relative 'queen'
require_relative 'pawn'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'

def new_game
  8.times do |i|
    player1.pieces << Pawn.new(white + pawn, [6, i])
    player2.pieces << Pawn.new(black + pawn, [1, i])
    player1.pieces << set_pieces(white, 7, i)
    player2.pieces << set_pieces(black, 0, i)
  end
end

def set_pieces(color, row, i)
  set = [
        Rook.new(color + rook, [row, i]),
        Knight.new(color + knight, [row, i]),
        Bishop.new(color + bishop, [row, i]),
        Queen.new(color + queen, [row, i]),
        King.new(color + king, [row, i]),
        Bishop.new(color + bishop, [row, i]),
        Knight.new(color + knight, [row, i]),
        Rook.new(color + rook, [row, i])
        ]
  set[i]
end

def load_game 
  puts "available save files:"
  choice = pick_save_data
  data = File.open("saves/#{choice}.yaml", 'r').read
  saved_data = YAML.load data
  saved_data
end

def save_game(data) 
  Dir.mkdir('saves') unless Dir.exist?('saves')
  puts "Available save slots:"
  choice = pick_save_data
  filename = "saves/#{choice}.yaml"
  File.open(filename, 'w') do |file| 
    file.puts data
  end
  puts "\e[32mYour game has been saved!\e[0m"
end

def pick_save_data
  list = Dir.glob('saves/*').each do |save|
    save.gsub!(%r{(saves/)(test\d)(.yaml)}, '\2')
  end
  list.each { |s| puts "\e[32m#{s}\e[0m" }
  choice = gets.chomp
  until list.include?(choice)
    puts 'Could not find save file. Try again.'
    choice = gets.chomp
  end
  choice
end