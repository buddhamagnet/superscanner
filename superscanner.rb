class Product
	attr_accessor :name, :unit_price, :unit
	attr_reader :rules

	def initialize(name, unit_price, unit, rules = {})
		@name = name
		@unit_price = unit_price
		@unit = unit
		@rules = rules
	end

	def add_rule(rule)
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
  attr_accessor :name, :amount, :price, :start, :fin

  def initialize(name, amount, price, start = nil, fin = nil)
    @name = name
    @amount = amount
    @price = price
    @start = start
    @fin = fin
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

    else

    end
  end

  # return total price

  def total
    total_price = 0

    @basket.each_pair do |product, amount|

    product_pricing_rules

    end

    total_price
  end

  private

  def apply_pricing_rules(product, amount, pricing_rules)
    price = 0

    # sort pricing rules by unit price
    pricing_rules.sort!{|a,b| a.unit_price <=> b.unit_price}

    pricing_rules.each do |pricing_rule|

    end

    return price, amount
  end
end
