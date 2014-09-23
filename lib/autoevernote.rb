require 'active_support/all'
require 'configurations'
require "autoevernote/version"

module AutoEvernote
  include Configurations

  autoload :Asana,    "autoevernote/asana"
  autoload :Klout,    "autoevernote/klout"
  autoload :Evernote, "autoevernote/evernote"

  default_config = File.expand_path('~/.autoevernote.yml')

  if File.exist?(default_config)
    require 'yaml'
    AutoEvernote.configure do |c|
      c.from_h(YAML.load_file(default_config))
    end
  end
end
