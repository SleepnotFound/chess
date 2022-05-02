class Player
  attr_writer :name

  def initialize
    @name = nil
    @pieces = []
  end
end