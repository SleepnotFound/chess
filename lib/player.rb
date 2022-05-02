require_relative 'pieces'

class Player
  include Pieces

  attr_accessor :name, :pieces 

  def initialize(color)
    @name = nil
    @color = color
    @pieces = []
  end
end