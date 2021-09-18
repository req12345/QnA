class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  after_action :publish_answer, only: [:create]

  def create
    @question_id = params[question.id]
    @answer = question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
     if current_user.author_of?(answer)
       answer.destroy
       flash.now[:alert] = 'Your answer deleted'
       set_question
     end
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      set_question
    end
  end

  def mark_as_best
    set_question
    if current_user.author_of?(question)
      question.set_best_answer(answer)
    end
	end

  private

  def publish_answer
    return if question.errors.any?
    ActionCable.server.broadcast(
      "answers/#{params[:question_id]}",
      ApplicationController.render_with_signed_in_user(
       current_user,
       partial: 'answers/answer_channel',
       locals: { question: answer.question, answer: answer }
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
