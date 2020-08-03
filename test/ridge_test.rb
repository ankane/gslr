require_relative "test_helper"

class RidgeTest < Minitest::Test
  def test_intercept
    x = [[1, 3], [2, 3], [3, 5], [4, 5]]
    y = [10, 11, 16, 17]

    model = GSLR::Ridge.new
    model.fit(x, y)

    assert_equal 2, model.coefficients.size
    assert_in_delta 1.21428571, model.coefficients[0]
    assert_in_delta 1.42857143, model.coefficients[1]
    assert_in_delta 4.75, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 10.25, predictions[0]
  end

  def test_no_intercept
    x = [[1, 3], [2, 3], [3, 5], [4, 5]]
    y = [10, 11, 16, 17]

    model = GSLR::Ridge.new(intercept: false)
    model.fit(x, y)

    assert_equal 2, model.coefficients.size
    assert_in_delta 0.88669951, model.coefficients[0]
    assert_in_delta 2.73891626, model.coefficients[1]
    assert_in_delta 0, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 9.10344828, predictions[0]
  end

  def test_alpha
    x = [[1, 3], [2, 3], [3, 5], [4, 5]]
    y = [10, 11, 16, 17]

    model = GSLR::Ridge.new(alpha: 4.0)
    model.fit(x, y)

    assert_equal 2, model.coefficients.size
    assert_in_delta 1, model.coefficients[0]
    assert_in_delta 1, model.coefficients[1]
    assert_in_delta 7, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 11, predictions[0]
  end

  def test_weight
    skip "Not supported yet"

    x = [[1, 3], [2, 3], [3, 5], [4, 5]]
    y = [10, 11, 16, 17]
    w = [1, 2, 3, 4]

    model = GSLR::Ridge.new
    model.fit(x, y, weight: w)

    assert_equal 2, model.coefficients.size
    assert_in_delta 1.16751269, model.coefficients[0]
    assert_in_delta 1.64467005, model.coefficients[1]
    assert_in_delta 4.06091371, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 10.16243655, predictions[0]
  end

  def test_weight_no_intercept
    x = [[1, 3], [2, 3], [3, 5], [4, 5]]
    y = [10, 11, 16, 17]
    w = [1, 2, 3, 4]

    model = GSLR::Ridge.new(intercept: false)
    model.fit(x, y, weight: w)

    assert_equal 2, model.coefficients.size
    assert_in_delta 0.85271318, model.coefficients[0]
    assert_in_delta 2.74197121, model.coefficients[1]
    assert_in_delta 0, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 9.0786268, predictions[0]
  end

  def test_numo
    x = Numo::SFloat.cast([[1, 3], [2, 3], [3, 5], [4, 5]])
    y = Numo::Int64.cast([10, 11, 16, 17])

    model = GSLR::Ridge.new
    model.fit(x, y)

    assert_equal 2, model.coefficients.size
    assert_in_delta 1.21428571, model.coefficients[0]
    assert_in_delta 1.42857143, model.coefficients[1]
    assert_in_delta 4.75, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 10.25, predictions[0]
  end
end
