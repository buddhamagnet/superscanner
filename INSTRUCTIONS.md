### Super scanner exercise instructions

The following exercise requires the developer to build a testable or runnable algorithm and supporting
code around a product and pricing system with an associated checkout process.

#### Step 1

Let us assume that every product will be represented by a Product class and store data in a products table (or in a products collection for a NoSQL solution).

Every product has a name, unit price and unit item (item, kg, etc.)

Special offers are represented by pricing rules. As for products, this can be a database table or NoSQL collection.

Every pricing rule has a product ID, name, amount and price.

Based on the above information we can calculate the unit price for every pricing rule. This can be used in the checkout algorithm.

#### Bonus exercise

Pricing rules can have an optional start and end date, making them available for certain periods. Pricing rules that are not active according to these criteria can be filtered out of the checkout process.

During the checkout all details about applied pricing rules should be visible in the logs. This information should be also available for every order from the database:

*price_elements
­*order_id
­*pricing_rule_id
*amount
­*price

The price element can represent a pricing rule or standard product price (record without pricing_rule_id). There is also an amount which indicates how many times a specific rule has been applied or the number of items or weight for a standard unit price.

### Step 2

Below is an implementation of the CheckOut class*. Pricing rules are passed into the constructor. There is a method for scanning products and counting the number of specific products in the basket object.

The total price depends on the set of pricing rules for each product. When there is no pricing rule the standard unit price is taken into account.

When pricing rules exist for a product in tbe basket they are sorted based on unit price.

If a specific unit price is lower than the standard unit price and the amount is also suitable the specific pricing rule is applied.

* There is also a subtle bug in this implementation that needs to be addressed.

```ruby
# Represent a check out
class CheckOut
# basket of products
# key [Product]
# value [Integer] quantity of products
  attr_reader :basket
  # @param pricing_rules [Hash]
  def initialize(pricing_rules = {})
    @pricing_rules = pricing_rules
    @basket = {}
  end

  def scan(product)
    if @basket[product]
      @basket[product] = @basket[product] + 1
    else
      @basket[product] = 1
    end
  end

  # return total price
  def total
    total_price = 0
    @basket.each_pair do |product, amount|
      product_pricing_rules = @pricing_rules[product.id]
      if product_pricing_rules && !product_pricing_rules.empty?
        price, amount = apply_pricing_rules product, amount, product_pricing_rules
        total_price += price
      end
      total_price += product.unit_price * amount if amount > 0
    end
    total_price
  end

  private

  def apply_pricing_rules(product, amount, pricing_rules) price = 0
    # sort pricing rules by unit price pricing_rules.sort!{|a,b| a.unit_price <=> b.unit_price}
    pricing_rules.each do |pricing_rule|
    # if pricing rule unit price is greater than default break
    break if pricing_rule.unit_price > product.unit_price
    # if amount is bigger than pricing rule amount, apply
    while amount >= pricing_rule.amount
      price += pricing_rule.price
      amount ­= pricing_rule.amount end
    end
    return price, amount
 end
end
```