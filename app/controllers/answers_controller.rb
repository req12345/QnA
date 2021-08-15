class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question, notice: 'Your answer successfully created'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer
end
