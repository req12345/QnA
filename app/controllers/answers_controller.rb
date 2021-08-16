class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
     if current_user.author_of?(answer)
       answer.destroy
       redirect_to question_path(answer.question), notice: 'Your answer deleted'
     else
       redirect_to question_path(answer.question)
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
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :question, :answer
end
