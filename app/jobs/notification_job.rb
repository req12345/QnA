class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotificationService.new(answer).send_notification
  end
end
