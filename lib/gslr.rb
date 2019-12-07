# stdlib
require "fiddle/import"

# modules
require "gslr/model"
require "gslr/ols"
require "gslr/ridge"
require "gslr/version"

module GSLR
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  self.ffi_lib =
    if Gem.win_platform?
      ["gsl.dll"]
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      ["libgsl.dylib"]
    else
      ["libgsl.so"]
    end

  # friendlier error message
  autoload :FFI, "gslr/ffi"
end
