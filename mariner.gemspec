# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mariner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jesse Trimble", "Adam Albrecht"]
  gem.email         = ["jlowelltrim@gmail.com", "adam.albrecht@gmail.com"]
  gem.description   = %q{A DSL for creating navigation structures based on the Rails routing table using Abyss.}
  gem.summary       = %q{A DSL for creating navigation structures based on the Rails routing table using Abyss.}
  gem.homepage      = ""

  gem.add_dependency 'abyss'
  gem.add_dependency 'rails', '~> 3.2.0'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mariner"
  gem.require_paths = ["lib"]
  gem.version       = Mariner::VERSION
end
