require 'minitest/autorun'
require 'timecop'

load 'superscanner.rb'

class TestProducts < Minitest::Test

  def test_sort_products
    products = [
      Product.new(1, "elder wand", 1540, "item"),
      Product.new(2, "invisibilty cloak", 1000, "item"),
      Product.new(3, "space dust", 100, "kg"),
      Product.new(4, "melange", 19456, "kg"),
      Product.new(5, "mithril", 23234, "kg"),
      Product.new(6, "google glass", 850, "pair")
    ]
    products.sort!
    assert_equal 100, products.first.unit_price
    assert_equal 23234, products.last.unit_price
  end
end

class TestPricingRule < Minitest::Test
  def setup
    @rule_1 = PricingRule.new(1, "two for one", 2, 1540)
    @rule_2 = PricingRule.new(1, "two for one", 2, 1540, Time.now, nil)
    @rule_3 = PricingRule.new(1, "two for one", 2, 1540, nil, Time.now)
    @rule_4 = PricingRule.new(1, "two for one", 2, 1540, Time.now, Time.now + 86400)
  end

  def test_no_time_limit
    assert @rule_1.no_time_limit
  end

  def test_no_end_time
    assert @rule_2.no_time_limit
  end

  def test_started
    assert @rule_2.started?
  end

  def test_not_started
    Timecop.freeze(Date.today - 30) do
      assert @rule_2.not_started?
    end
  end

  def test_no_start_time
    assert @rule_3.no_time_limit
  end

  def test_expired
    Timecop.freeze(Date.today + 150) do
      assert @rule_3.expired?
    end
  end

  def test_timeboxed
    assert @rule_4.timeboxed?
  end

  def test_active
    assert @rule_4.active?
  end
end

class TestCheckout < Minitest::Test
  def setup
    @checkout = CheckOut.new
  end

  def test_initial_basket_state
    assert @checkout.basket.empty?
  end
end
