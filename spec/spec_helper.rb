require 'coveralls'
Coveralls.wear!

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

require 'autoevernote'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
  config.before do
    AutoEvernote.configure do |c|
      c.from_h(YAML.load_file(File.expand_path('../fixtures/autoevernote.yml', __FILE__)))
    end
  end
end

