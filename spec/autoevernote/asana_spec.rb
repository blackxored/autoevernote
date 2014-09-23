require 'spec_helper'

module AutoEvernote
  describe Asana do
    let(:client) { described_class.new }

    it "returns completed tasks" do
      with_completed_tasks do
        expect(client.completed_tasks.all?(&:completed)).to eq(true)
      end
    end

    it "returns tasks that were completed today" do
      with_completed_tasks do
        client.completed_tasks_for_today.each do |task|
          puts "#{task.name}: #{task.completed?}"
        end
      end
    end

    def with_completed_tasks(&block)
      VCR.use_cassette('completed_tasks', &block)
    end
  end
end
