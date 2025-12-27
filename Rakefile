require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task default: :test

task :benchmark do
  require "benchmark"
  require "gslr"
  require "numo/narray"

  x = Numo::DFloat.new(100000, 10).rand
  y = Numo::DFloat.new(100000).rand

  model = GSLR::OLS.new

  p Benchmark.realtime { model.fit(x, y) }.round(3)
end
