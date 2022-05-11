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
