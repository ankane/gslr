require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def setup
    # autoload before GC.stress
    GSLR::FFI if stress?

    GC.stress = true if stress?
  end

  def teardown
    GC.stress = false if stress?
  end

  def stress?
    ENV["STRESS"]
  end

  def numo?
    !["jruby", "truffleruby"].include?(RUBY_ENGINE)
  end
end
