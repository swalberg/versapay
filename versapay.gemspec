# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "versapay/version"

Gem::Specification.new do |s|
  s.name        = "versapay"
  s.version     = Versapay::VERSION
  s.authors     = ["Sean Walberg"]
  s.email       = ["sean@ertw.com"]
  s.homepage    = ""
  s.summary     = %q{A gem to use the Versapay API}
  s.description = %q{A gem to use the Versapay API}

  s.rubyforge_project = "versapay"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rails", "2.3.11"
  s.add_development_dependency "activesupport", "2.3.11"
  s.add_development_dependency "fakeweb"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "rest-client"
end
