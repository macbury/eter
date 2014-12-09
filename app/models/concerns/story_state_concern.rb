require 'active_support/concern'

module StoryStateConcern
  extend ActiveSupport::Concern
  included do
    include ActiveModel::Transitions

    state_machine do
      state :unscheduled
      state :unstarted
      state :started
      state :finished
      state :delivered
      state :accepted
      state :rejected
      event :start do
        transitions :to => :started, :from => [:unstarted, :unscheduled]
      end
      event :finish do
        transitions :to => :finished, :from => :started
      end
      event :deliver do
        transitions :to => :delivered, :from => :finished
      end
      event :accept do
        transitions :to => :accepted, :from => :delivered
      end
      event :reject do
        transitions :to => :rejected, :from => :delivered
      end
      event :restart do
        transitions :to => :started, :from => :rejected
      end
    end
  end
end
