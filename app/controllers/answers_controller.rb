class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params.merge(author: current_user))

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
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
