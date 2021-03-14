# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Don't check coverage when running individual spec files
if ARGV.grep(/spec\.rb/).empty?
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/test/'
    add_filter '/db/'
    add_filter '/app/channels/'
    add_filter '/app/mailers/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Jobs',        'app/jobs'
    add_group 'Models',      'app/models'
    add_group 'Services',    'app/services'
    add_group 'Libraries',   'app/lib'

    track_files '{app,lib}/**/*.rb'
  end
end
