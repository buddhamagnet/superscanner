class PricingRule
  include Comparable

  attr_accessor :name, :amount, :price, :start, :fin

  def initialize(name, amount, price, start = nil, fin = nil)
    @name = name
    @amount = amount
    @price = price
    @start = start
    @fin = fin
  end

  def <=>(other)
    price <=> other.price
  end

  def timeboxed?
    start && fin
  end

  def no_time_limit
    !(start && fin)
  end

  def expired?
    fin < Time.now
  end

  def not_started?
    start > Time.now
  end

  def started?
    start < Time.now
  end

  def active?
    no_time_limit || (timeboxed? && start < Time.now && fin > Time.now)
  end
end
