module Pieces
  def blank_space;  " "      end
  def reset;        "\e[0m"  end
  def white;        "\e[97m" end
  def black;        "\e[30m" end
  def cyan;         "\e[96m" end
  def red;          "e\[31m" end

  def king;         "\u265A" end
  def queen;        "\u265B" end
  def rook;         "\u265C" end
  def bishop;       "\u265D" end
  def knight;       "\u265E" end
  def pawn;         "\u265F" end
  def f_circle;     "\u25CF" end
end