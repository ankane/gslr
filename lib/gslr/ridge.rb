module GSLR
  class Ridge < Model
    def initialize(alpha: 1.0, **options)
      super(**options)
      @alpha = alpha
    end

    def fit(x, y, weight: nil)
      if @fit_intercept
        # the intercept should not be regularized
        # so we need to center x and y
        # and exclude the intercept
        xc, x_offset, s1, s2 = centered_matrix(x)
        yc, y_offset = centered_vector(y)

        if weight
          # TODO apply weights before centering
          # not a great way to calculate and subtract the mean
          # with GSL and FFI
          raise "weight not supported with intercept yet"
        end
      else
        xc, s1, s2 = set_matrix(x, intercept: false)
        yc = set_vector(y)

        if weight
          wc = set_vector(weight)
          # in place transformation
          check_status FFI.gsl_multifit_linear_applyW(xc, wc, yc, xc, yc)
        end
      end

      # allocate solution
      c = FFI.gsl_vector_alloc(s2)
      rnorm = Fiddle::Pointer.malloc(Fiddle::SIZEOF_DOUBLE, Fiddle::RUBY_FREE)
      snorm = Fiddle::Pointer.malloc(Fiddle::SIZEOF_DOUBLE, Fiddle::RUBY_FREE)
      work = FFI.gsl_multifit_linear_alloc(s1, s2)

      # fit
      check_status FFI.gsl_multifit_linear_svd(xc, work)
      check_status FFI.gsl_multifit_linear_solve(Math.sqrt(@alpha), xc, yc, c, rnorm, snorm, work)

      # read solution
      c_ptr = FFI.gsl_vector_ptr(c, 0)
      @coefficients = c_ptr[0, s2 * Fiddle::SIZEOF_DOUBLE].unpack("d*")
      @intercept =
        if @fit_intercept
          y_offset - x_offset.zip(@coefficients).map { |xii, c| xii * c }.sum
        else
          0.0
        end

      nil
    ensure
      FFI.gsl_matrix_free(xc) if xc
      FFI.gsl_vector_free(yc) if yc
      FFI.gsl_vector_free(c) if c
      FFI.gsl_multifit_linear_free(work) if work
    end

    private

    def centered_matrix(x)
      if numo?(x)
        x = dfloat(x)
        x_offset = x.mean(axis: 0)
        x = x - x_offset
        xc, s1, s2 = set_matrix(x, intercept: false)
      else
        x_offset = []
        x.first.size.times do |i|
          x_offset << x.map { |xi| xi[i] }.sum / x.size.to_f
        end

        s1, s2 = shape(x)
        xc = FFI.gsl_matrix_alloc(s1, s2)
        x_ptr = FFI.gsl_matrix_ptr(xc, 0, 0)

        # pack efficiently
        str = String.new
        x.each do |xi|
          xi.zip(x_offset).map { |v, o| v - o }.pack("d*", buffer: str)
        end
        x_ptr[0, str.bytesize] = str
      end

      [xc, x_offset.to_a, s1, s2]
    end

    def centered_vector(y)
      if numo?(y)
        y = dfloat(y)
        y_offset = y.mean(axis: 0)
      else
        y_offset = y.sum / y.size.to_f
      end

      yc = set_vector(y)
      check_status FFI.gsl_vector_add_constant(yc, -y_offset)

      [yc, y_offset]
    end
  end
end
