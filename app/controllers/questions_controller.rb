class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: [:create]

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
    question.build_reward
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
    redirect_to questions_path, alert: 'Your question deleted'
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      ApplicationController.render_with_signed_in_user(
       current_user,
       partial: 'questions/question_channel',
       locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url,:_destroy, :id],
                                     reward_attributes: [:name, :image])
  end

  helper_method :question
end
