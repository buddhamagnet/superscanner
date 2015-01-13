# This test has been completed using Plain Old Ruby Objects to simply demonstrate the algorithm
# and demonstrate that I can code Ruby as well as Rails!

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

class PricingRule
  include Comparable

  attr_accessor :name, :amount, :price, :start, :fin, :product_id

  def initialize(pid, name, amount, price, start = nil, fin = nil)
    @product_id = pid
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
    start < Time.now && fin > Time.now
  end
end

class CheckOut

  attr_reader :basket

  def initialize(pricing_rules = {})
    @pricing_rules = pricing_rules
    @basket = {}
  end

  def scan(product)
    if @basket[product]
      @basket[product] += 1
    else
      @basket[product] = 1
    end
  end

  def total
    total_price = 0

    @basket.each_pair do |product, amount|

      product_pricing_rules = @pricing_rules[product.id]
    
      if product_pricing_rules && product_pricing_rules.any?
        price, amount = apply_pricing_rules(product, amount, product_pricing_rules)
        total_price += price
      end

      total_price += product.unit_price * amount if amount > 0
    end
    total_price
  end

  private

  def apply_pricing_rules(product, amount, pricing_rules)
    price = 0

    pricing_rules.sort!{|a,b| a.unit_price <=> b.unit_price}

    pricing_rules.each do |pricing_rule|
      
      break if pricing_rule.unit_price > product.unit_price

      while amount >= pricing_rule.amount
        price += pricing_rule.price
        amount -= pricing_rule.amount
      end
    end

    return price, amount
  end
end
