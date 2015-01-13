# This test has been completed using Plain Old Ruby Objects to simply demonstrate the algorithm
# and demonstrate that I can code Ruby as well as Rails!

class Product
  include Comparable

	attr_accessor :name, :unit_price, :unit
	attr_reader :id, :rules

	def initialize(id, name, unit_price, unit, rules = {})
    @id = id
		@name = name
		@unit_price = unit_price
		@unit = unit
		@rules = rules
	end

  def <=>(other)
    unit_price <=> other.unit_price
  end

	def add_rule(rule)
    rule.product_id = id
		rules[rule.name] = rule
	end

	def rule_price(name)
		unit_price * rules[name].amount
	end

	def rule_size
		rules.size
	end
end

class PricingRule
  include Comparable

  attr_accessor :name, :amount, :price, :start, :fin, :product_id

  def initialize(name, amount, price, start = nil, fin = nil)
    @name = name
    @amount = amount
    @price = price
    @start = start
    @fin = fin
  end

  def <=>(other)
    unit_price <=> other.price
  end

  def timeboxed?
  	start && fin
  end
end

class CheckOut

# key [Product]

# value [Integer] quantity of products

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
    
      if product_picing_rules && !product_pricing_rules.empty?
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
