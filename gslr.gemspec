require_relative "lib/gslr/version"

Gem::Specification.new do |spec|
  spec.name          = "gslr"
  spec.version       = GSLR::VERSION
  spec.summary       = "High performance linear regression for Ruby, powered by GSL"
  spec.homepage      = "https://github.com/ankane/gslr"
  spec.license       = "GPL-3.0-or-later"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.7"
end
