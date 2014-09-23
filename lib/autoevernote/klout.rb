# TODO: move to autoevernote.rb if other services require this on the future
require 'httparty'

module AutoEvernote
  class Klout
    attr_reader :klout_id, :api_key

    include HTTParty
    base_uri "http://api.klout.com/v2/"
    default_params key: AutoEvernote.configuration.klout.token

    def initialize(klout_id = nil)
      @klout_id = klout_id
    end

    def twitter_identity(username)
      self.class.get("/identity.json/twitter", query: { screenName: username })['id']
    end

    def score(username)
      response = self.class.get("/user.json/#{twitter_identity(username)}/score")
      {
        score: response['score'].round(2),
        monthly_change: response['scoreDelta']['monthChange'].round(2)
      }
    end
  end
end
