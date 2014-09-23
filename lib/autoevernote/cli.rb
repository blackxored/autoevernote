require 'thor'
require 'autoevernote'

module AutoEvernote
  class CLI < Thor
    desc "version", "Return the version of autoevernote"
    def version
      puts AutoEvernote::VERSION
    end

    desc "log_completed_tasks", "Log today's completed tasks in Asana to Evernote"
    def log_completed_tasks
      puts "Retrieving completed tasks"
      AutoEvernote::Evernote.new.create_note_from_hash(AutoEvernote::Asana.new.to_note)
    end

    desc "compute_stats", "Log quantified-self stats (followers, etc) to Evernote"
    def compute_stats
      evernote = AutoEvernote::Evernote.new
      asana    = AutoEvernote::Asana.new
      klout    = AutoEvernote::Klout.new.score(
        AutoEvernote.configuration.twitter.username
      )
      twitter_id          = AutoEvernote.configuration.twitter.id
      twitter_counter_api = AutoEvernote.configuration.twitter.counter_token

      twitter_stats = HTTParty.get("http://api.twittercounter.com", query: {
        apikey: twitter_counter_api,
        twitter_id: twitter_id
      })

      written_tasks_in_month   = asana.tasks.select(&in_month_by(:created_at))
      completed_tasks_in_month = asana.completed_tasks.select(&in_month_by(:completed_at))

      note = {
        title: "Stats for #{Date.today.strftime('%B %Y')}",
        notebook: "Main",
        body: "<ul>",
        tags: ['baseline']
      }

      note[:body] += "<li><b>Twitter followers:</b> #{twitter_stats['followers_current']}</li>"
      note[:body] += "<li><b>Klout Score:</b> #{klout[:score]} (#{klout[:monthly_change]})</li>"
      note[:body] += "<li><b>Written tasks:</b> #{written_tasks_in_month.size}</li>"
      note[:body] += "<li><b>Completed tasks:</b> #{completed_tasks_in_month.size}</li>"
      note[:body] += "</ul>"

      evernote.create_note_from_hash(note)
    end

    private
    def in_month_by(field)
      ->(task) { task.public_send(field) ? 1.month.ago <= Time.parse(task.public_send(field)) : false }
    end
  end
end
