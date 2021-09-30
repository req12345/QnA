class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)

  end
end
