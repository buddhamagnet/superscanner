class Product
  include Comparable

  attr_accessor :name, :unit_price, :unit
  attr_reader :id

  def initialize(id, name, unit_price, unit)
    @id = id
    @name = name
    @unit_price = unit_price
    @unit = unit
  end

  def <=>(other)
    unit_price <=> other.unit_price
  end
end
