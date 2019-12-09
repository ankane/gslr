module GSLR
  module FFI
    extend Fiddle::Importer

    # must link a cblas lib on some platforms
    # https://lists.gnu.org/archive/html/bug-gsl/2017-04/msg00008.html
    if GSLR.cblas_lib.any?
      libs = GSLR.cblas_lib.dup
      begin
        Fiddle.dlopen(libs.shift)
      rescue Fiddle::DLError => e
        retry if libs.any?
        raise e if ENV["GSLR_DEBUG"]
        raise LoadError, "Could not find GSL"
      end
    end

    libs = GSLR.ffi_lib.dup
    begin
      dlload Fiddle.dlopen(libs.shift)
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e if ENV["GSLR_DEBUG"]
      raise LoadError, "Could not find GSL"
    end

    # https://www.gnu.org/software/gsl/doc/html/err.html
    extern "char * gsl_strerror(int gsl_errno)"

    # https://www.gnu.org/software/gsl/doc/html/vectors.html
    extern "gsl_vector * gsl_vector_alloc(size_t n)"
    extern "void gsl_vector_free(gsl_vector * v)"
    extern "double * gsl_vector_ptr(gsl_vector * v, size_t i)"
    extern "int gsl_vector_add_constant(gsl_vector * a, double x)"
    extern "gsl_matrix * gsl_matrix_alloc(size_t n1, size_t n2)"
    extern "void gsl_matrix_free(gsl_matrix * m)"
    extern "double * gsl_matrix_ptr(gsl_matrix * m, size_t i, size_t j)"

    # https://www.gnu.org/software/gsl/doc/html/lls.html
    extern "int gsl_multifit_linear(gsl_matrix * X, gsl_vector * y, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)"
    extern "int gsl_multifit_wlinear(gsl_matrix * X, gsl_vector * w, gsl_vector * y, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)"
    extern "gsl_multifit_linear_workspace * gsl_multifit_linear_alloc(size_t n, size_t p)"
    extern "void gsl_multifit_linear_free(gsl_multifit_linear_workspace * work)"
    extern "int gsl_multifit_linear_solve(double lambda, gsl_matrix * Xs, gsl_vector * ys, gsl_vector * cs, double * rnorm, double * snorm, gsl_multifit_linear_workspace * work)"
    extern "int gsl_multifit_linear_svd(gsl_matrix * X, gsl_multifit_linear_workspace * work)"
  end
end
