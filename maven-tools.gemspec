# -*- mode:ruby -*-
# -*- coding: utf-8 -*-
require File.expand_path('lib/maven/tools/version.rb')
Gem::Specification.new do |s|
  s.name = 'maven-tools'
  s.version = Maven::Tools::VERSION.dup

  s.summary = 'helpers for maven related tasks'
  s.description = 'adds versions conversion from rubygems to maven and vice versa, ruby DSL for POM (Project Object Model from maven), pom generators, etc'
  s.homepage = 'http://github.com/torquebox/maven-tools'

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']

  s.license = 'MIT'

  s.files += Dir['*.gemspec']
  s.files += Dir['*file']
  s.files += Dir['lib/**/*rb']
  s.files += Dir['spec/**/*rb']
  s.files += Dir['MIT-LICENSE'] + Dir['*.md']
  s.test_files += Dir['spec/**/*.rb']
  s.test_files += Dir['spec/**/*.java']
  s.test_files += Dir['spec/**/*.xml']
  s.test_files += Dir['spec/**/*file']
  s.test_files += Dir['spec/**/*.lock']
  s.test_files += Dir['spec/**/.keep']
  s.test_files += Dir['spec/**/*gemspec']
  s.test_files += Dir['spec/**/*gem']

  s.add_runtime_dependency 'dry-container', '~> 0.7.2'
  s.add_runtime_dependency 'dry-configurable', '~> 0.12.1'
  s.add_runtime_dependency 'dry-core', '~> 0.6.0'
  s.add_runtime_dependency 'dry-inflector', '~> 0.2.0'
  s.add_runtime_dependency 'dry-types', '~> 1.5.1'
  s.add_runtime_dependency 'dry-struct', '~> 1.4.0'
  s.add_runtime_dependency 'dry-struct-setters', '~> 0.4.0'


# get them out from here until jruby-maven-plugin installs test gems somewhere else then runtime gems

  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.3'
end

# vim: syntax=Ruby
