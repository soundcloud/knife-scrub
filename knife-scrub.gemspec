# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'knife-scrub/version'

Gem::Specification.new do |s|
  s.name        = 'knife-scrub'
  s.version     = Knife::Scrub::VERSION
  s.authors     = ['Tobias Schmidt']
  s.email       = ['ts@soundcloud.com']
  s.homepage    = 'https://github.com/soundcloud/knife-scrub'
  s.summary     = 'knife plugin to scrub normal attributes of chef-server'
  s.description = 'Collection of knife plugins to remove orphaned objects from chef-server'
  s.license     = 'Apache 2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'chef', '>= 10.26.0'
  s.add_development_dependency 'rake'
end
