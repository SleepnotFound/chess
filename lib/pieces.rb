module Pieces
  def blank_space;  " "      end

  def white_king;   "\e[97m\u265A" end
  def white_queen;  "\e[97m\u265B" end
  def white_rook;   "\e[97m\u265C" end
  def white_bishop; "\e[97m\u265D" end
  def white_knight; "\e[97m\u265E" end
  def white_pawn;   "\e[97m\u265F" end

  def black_king;   "\e[30m\u265A" end
  def black_queen;  "\e[30m\u265B" end
  def black_rook;   "\e[30m\u265C" end
  def black_bishop; "\e[30m\u265D" end
  def black_knight; "\e[30m\u265E" end
  def black_pawn;   "\e[30m\u265F" end
  
  def black_row(piece)
    "\e[100m  #{piece}   \e[0m\n" 
  end
  
  def white_row(piece)
    "\e[47m  #{piece}   \e[0m\n" 
  end
  
  def build_tile(tile, piece = blank_space)
    if tile == 'white'
      white_row(blank_space) + white_row(piece) + white_row(blank_space)
    elsif tile == 'black'
      black_row(blank_space) + black_row(piece) + black_row(blank_space)
    end
  end
end