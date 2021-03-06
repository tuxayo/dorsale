module Dorsale
  module Flyboy
    class TaskComment < ActiveRecord::Base
      self.table_name = "dorsale_flyboy_task_comments"

      belongs_to :task

      validates :task,        presence: true
      validates :date,        presence: true
      validates :description, presence: true
      validates :progress, inclusion: {in: 0..100}

      default_scope -> { order("created_at DESC") }

      def initialize(*args)
        super

        self.date     = Time.now if date.nil?

        if progress.nil?
          self.progress = task ? task.progress : 0
        end
      end

      after_create :update_task_progress

      def update_task_progress
        task.update_attributes(
          :progress => progress,
          :done     => progress.equal?(100)
        )
      end
    end
  end
end
