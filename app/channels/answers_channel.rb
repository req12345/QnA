class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "answers/#{params['question_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
