class AnswersController < ApplicationController
  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body, :question_id)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer
end
