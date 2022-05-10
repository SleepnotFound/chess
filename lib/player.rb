require_relative 'pieces'

class Player
  include Pieces

  attr_accessor :name, :pieces 

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
  end
end