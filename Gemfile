source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'puppetlabs_spec_helper', '~> 2.6.0',                         :require => false
  gem 'rspec-puppet', '~> 2.5',                                     :require => false
  gem 'rspec-puppet-facts',                                         :require => false
  gem 'rspec-puppet-utils',                                         :require => false
  gem 'puppet-lint-leading_zero-check',                             :require => false
  gem 'puppet-lint-trailing_comma-check',                           :require => false
  gem 'puppet-lint-version_comparison-check',                       :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  :require => false
  gem 'puppet-lint-unquoted_string-check',                          :require => false
  gem 'puppet-lint-variable_contains_upcase',                       :require => false
  gem 'metadata-json-lint',                                         :require => false
  gem 'redcarpet',                                                  :require => false
  gem 'rubocop', '~> 0.49.1',                                       :require => false if RUBY_VERSION >= '2.3.0'
  gem 'rubocop-rspec', '~> 1.15.0',                                 :require => false if RUBY_VERSION >= '2.3.0'
  gem 'mocha', '~> 1.4.0',                                          :require => false
  gem 'coveralls',                                                  :require => false
  gem 'rack', '~> 1.0',                                             :require => false if RUBY_VERSION < '2.2.2'
  gem 'parallel_tests',                                             :require => false
end


group :system_tests do
  gem 'beaker', '>= 3.9.0', :require => false
  gem 'beaker-rspec',  :require => false
  gem 'serverspec',                         :require => false
  gem 'beaker-hostgenerator', '>= 1.1.10',  :require => false
  gem 'beaker-puppet_install_helper',       :require => false
  gem 'beaker-module_install_helper',       :require => false
end

group :release do
  gem 'github_changelog_generator',  :require => false, :git => 'https://github.com/skywinder/github-changelog-generator' if RUBY_VERSION >= '2.2.2'
  gem 'puppet-blacksmith',           :require => false
  gem 'puppet-strings', '~> 1.0',    :require => false
end

gem 'facter', :require => false, :groups => [:test]

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~> 5.0' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
