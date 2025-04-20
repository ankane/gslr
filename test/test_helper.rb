require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def numo?
    !["jruby", "truffleruby"].include?(RUBY_ENGINE)
  end
end
