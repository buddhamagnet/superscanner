require 'minitest/autorun'
load 'superscanner.rb'

class TestSuperscanner < Minitest::Test
  def setup
    @product = Product.new(1, "invisibilty cloak", 1000, "item")
  end

  def test_empty_ruleset
    assert @product.rules.empty?
  end

  def test_add_rule
    @product.add_rule(PricingRule.new("three for a steal", 1, 2500))
    assert_equal 1, @product.rule_size
    assert_equal 1, @product.rules["three for a steal"].amount
    assert_equal 1000, @product.rule_price("three for a steal")
  end

  def test_add_product_link
    @product.add_rule(PricingRule.new("two for a steal", 1, 1500))
    assert_equal 1, @product.rules["two for a steal"].product_id
  end

  def test_timeboxing_start_only
    @product.add_rule(PricingRule.new("start but no end", 1, 2500, Time.now))
    assert !@product.rules["start but no end"].timeboxed?
  end

  def test_timeboxing_end_only
    @product.add_rule(PricingRule.new("end but no start", 1, 2500, nil, Time.now))
    assert !@product.rules["end but no start"].timeboxed?
  end

  def test_timeboxing_valid
    @product.add_rule(PricingRule.new("timeboxed", 1, 2500, Time.now, Time.now + 86400))
    assert @product.rules["timeboxed"].timeboxed?
  end
end
