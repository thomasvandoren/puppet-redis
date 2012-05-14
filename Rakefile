#!/usr/bin/ruby
require 'rake'

# default
task :default => [:spec, :lint]

# spec
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

# lint
require 'puppet-lint/tasks/puppet-lint'
