module GSLR
  class Model
    attr_reader :coefficients, :intercept

    def initialize(intercept: true)
      @fit_intercept = intercept
    end

    def predict(x)
      if numo?(x)
        x.dot(@coefficients) + @intercept
      else
        x.map do |xi|
          xi.zip(@coefficients).map { |xii, c| xii * c }.sum + @intercept
        end
      end
    end

    private

    def set_matrix(x, intercept:)
      s1, s2 = shape(x)
      s2 += 1 if intercept

      xc = FFI.gsl_matrix_alloc(s1, s2)
      x_ptr = FFI.gsl_matrix_ptr(xc, 0, 0)

      if numo?(x)
        if intercept
          ones = Numo::DFloat.ones(s1, 1)
          x = ones.concatenate(x, axis: 1)
        end
        set_data(x_ptr, x)
      else
        # pack efficiently
        str = String.new
        one = [1].pack("d*")
        x.each do |xi|
          str << one if intercept
          str << xi.pack("d*")
        end
        x_ptr[0, str.bytesize] = str
      end

      [xc, s1, s2]
    end

    def set_vector(x)
      v = FFI.gsl_vector_alloc(x.size)
      ptr = FFI.gsl_vector_ptr(v, 0)
      set_data(ptr, x)
      v
    end

    def set_data(ptr, x)
      if numo?(x)
        x = dfloat(x)
        ptr[0, x.byte_size] = x.to_string
      else
        str = x.pack("d*")
        ptr[0, str.bytesize] = str
      end
    end

    def shape(x)
      numo?(x) ? x.shape : [x.size, x.first.size]
    end

    def numo?(x)
      defined?(Numo::NArray) && x.is_a?(Numo::NArray)
    end

    def dfloat(x)
      x.is_a?(Numo::DFloat) ? x : x.cast_to(Numo::DFloat)
    end

    def check_status(status)
      raise Error, FFI.gsl_strerror(status).to_s if status != 0
    end
  end
end
