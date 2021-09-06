class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
    @answer.links.new
    @best_answer = question.best_answer
  end

  def new
    question.links.new
  end

  def create
    @question = current_user.questions.create(question_params)

    if question.save
      redirect_to question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(question)
      question.update(question_params)
    end
  end

  def destroy
    question.destroy if current_user.author_of?(question)
    redirect_to questions_path, notice: 'Your question deleted'
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url])
  end

  helper_method :question
end
