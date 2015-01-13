require 'forwardable'

class CheckOut
  extend Forwardable

  def_delegators :@basket, :[], :size

  attr_accessor :basket

  def initialize(pricing_rules = {})
    @pricing_rules = pricing_rules
    @basket = {}
  end

  def scan(product)
    if basket[product]
      basket[product] += 1
    else
      basket[product] = 1
    end
    self
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

    pricing_rules.sort!{|a,b| a.price <=> b.price}

    pricing_rules.each do |pricing_rule|
      
      break if pricing_rule.price > product.unit_price

      while amount >= pricing_rule.amount
        price += pricing_rule.price
        amount -= pricing_rule.amount
      end
    end

    return price, amount
  end
end
