require_relative "test_helper"

class OLSTest < Minitest::Test
  def test_intercept
    x = [[1, 3], [2, 3], [3, 5], [4, 5]]
    y = [10, 11, 16, 17]

    model = GSLR::OLS.new
    model.fit(x, y)

    assert_equal 2, model.coefficients.size
    assert_in_delta 1, model.coefficients[0]
    assert_in_delta 2, model.coefficients[1]
    assert_in_delta 3, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 10, predictions[0]
  end

  def test_no_intercept
    x = [[1], [2], [3], [4]]
    y = [5, 7, 9, 11]

    model = GSLR::OLS.new(intercept: false)
    model.fit(x, y)

    assert_equal 1, model.coefficients.size
    assert_in_delta 3, model.coefficients[0]
    assert_in_delta 0, model.intercept
  end

  def test_weight
    x = [[1], [2], [3], [4]]
    y = [5, 7, 9, 13]
    w = [1, 2, 3, 4]

    model = GSLR::OLS.new
    model.fit(x, y, weight: w)

    assert_equal 1, model.coefficients.size
    assert_in_delta 2.8, model.coefficients[0]
    assert_in_delta 1.4, model.intercept
  end

  def test_numo
    x = Numo::DFloat.cast([[1, 3], [2, 3], [3, 5], [4, 5]])
    y = Numo::DFloat.cast([10, 11, 16, 17])

    model = GSLR::OLS.new
    model.fit(x, y)

    assert_equal 2, model.coefficients.size
    assert_in_delta 1, model.coefficients[0]
    assert_in_delta 2, model.coefficients[1]
    assert_in_delta 3, model.intercept

    predictions = model.predict(x)
    assert_equal 4, predictions.size
    assert_in_delta 10, predictions[0]
  end

  def test_numo_weight
    x = Numo::SFloat.cast([[1], [2], [3], [4]])
    y = Numo::Int64.cast([5, 7, 9, 13])
    w = Numo::UInt8.cast([1, 2, 3, 4])

    model = GSLR::OLS.new
    model.fit(x, y, weight: w)

    assert_equal 1, model.coefficients.size
    assert_in_delta 2.8, model.coefficients[0]
    assert_in_delta 1.4, model.intercept
  end
end
