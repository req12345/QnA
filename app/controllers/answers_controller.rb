class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  after_action :publish_answer, only: [:create]

  authorize_resource
  
  def create
    @answer = question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
     if authorize! :destroy, answer
       answer.destroy
       flash.now[:alert] = 'Your answer deleted'
       set_question
     end
  end

  def update
    if authorize! :update, answer
      answer.update(answer_params)
      set_question
    end
  end

  def mark_as_best
    set_question
    if authorize! :mark_as_best, answer
      question.set_best_answer(answer)
    end
	end

  private

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast("answers/#{params[:question_id]}",
      ApplicationController.render(
       partial: 'answers/answer_channel',
       locals: { question: answer.question, answer: answer, current_user: current_user }
      )
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  def set_question
    @question = answer.question
  end

  helper_method :question, :answer
end
