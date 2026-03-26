require "bundler/gem_tasks"
require "rake/testtask"
require "ruby_memcheck"

test_config = lambda do |t|
  t.pattern = "test/**/*_test.rb"
end
Rake::TestTask.new(&test_config)

namespace :test do
  RubyMemcheck::TestTask.new(:valgrind, &test_config)
end

task default: :test

task :benchmark do
  require "benchmark"
  require "gslr"
  require "numo/narray/alt"

  x = Numo::DFloat.new(100000, 10).rand
  y = Numo::DFloat.new(100000).rand

  model = GSLR::OLS.new

  p Benchmark.realtime { model.fit(x, y) }.round(3)
end
