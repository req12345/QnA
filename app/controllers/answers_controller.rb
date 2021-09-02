class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
     if current_user.author_of?(answer)
       answer.destroy
       flash[:notice] = 'Your answer deleted'
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
    if current_user.author_of?(set_question)
  		question.update(best_answer_id: answer.id)
      @best_answer = answer
    end
	end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
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
