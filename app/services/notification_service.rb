class NotificationService
  attr_reader :answer

  def initialize(answer)
    @answer = answer
  end

  def send_notification
    @question = @answer.question
    @question.subscriptions.find_each do |subscription|
      NotificationMailer.notification(subscription.user, @answer).deliver_later
    end
  end
end
