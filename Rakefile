require 'puppetlabs_spec_helper/rake_tasks'

# This ensures that PuppetLint is available for configuration.
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send("disable_80chars")
