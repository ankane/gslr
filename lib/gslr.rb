# stdlib
require "fiddle/import"

# modules
require_relative "gslr/model"
require_relative "gslr/ols"
require_relative "gslr/ridge"
require_relative "gslr/version"

module GSLR
  class Error < StandardError; end

  class << self
    attr_accessor :cblas_lib, :ffi_lib
  end
  self.cblas_lib = []
  self.ffi_lib =
    if Gem.win_platform?
      ["gsl.dll"]
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        self.cblas_lib = ["libgslcblas.dylib", "/opt/homebrew/lib/libgslcblas.dylib"]
        ["libgsl.dylib", "/opt/homebrew/lib/libgsl.dylib"]
      else
        self.cblas_lib = ["libgslcblas.dylib"]
        ["libgsl.dylib"]
      end
    else
      self.cblas_lib = ["libgslcblas.so"]
      ["libgsl.so"]
    end

  # friendlier error message
  autoload :FFI, "gslr/ffi"
end
