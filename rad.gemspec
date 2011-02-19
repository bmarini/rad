# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rad/version"

Gem::Specification.new do |s|
  s.name        = "rad"
  s.version     = Rad::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Marini"]
  s.email       = ["bmarini@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{RESTful API Documentor}
  s.description = %q{Generate beautiful documentation for your restful api}

  s.rubyforge_project = "rad"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
