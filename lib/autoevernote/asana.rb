require 'asana'

module AutoEvernote
  class Asana
    def initialize
      @include_archived_tasks = true
      ::Asana.configure do |config|
        config.api_key = AutoEvernote.configuration.asana.token
      end
    end

    def projects
      @projects ||= ::Asana::Project.all
    end

    def workspaces
      @workspaces ||= ::Asana::Workspace.all
    end

    def tasks
      @tasks ||= all_tasks.flatten
    end

    def completed_tasks
      @completed_tasks ||= filter_completed_tasks
    end

    def completed_tasks_for_today
      @completed_tasks_for_today ||= completed_tasks.select do |task|
        task.completed_at.to_date == Time.now.to_date
      end
    end

    def to_note
      {
        title: "Completed #{completed_tasks_for_today.size} tasks on #{Time.now.to_date}",
        body:  build_note_body(completed_tasks_for_today),
        tags: ["asana"]
      }
    end

    private
      def all_tasks
        workspaces.map(&:tasks).reject(&:empty?)
      end

      def filter_completed_tasks
        tasks = workspaces.map { |w| w.tasks(include_archived: true) }
        tasks.reject(&:empty?).flatten.select(&:completed?)
      end

      def build_note_body(tasks)
        body = "<ul>"
        tasks.each do |task|
          body += "\n<li><a href='https://app.asana.com/0/#{task.workspace.id}/#{task.id}'>#{task.name}</a></li>"
        end
        body += "</ul>"
      end
  end
end
