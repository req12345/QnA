class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
    @answer.links.new
    @best_answer = question.best_answer
    gon.push({question_id: question.id})
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
    question.update(question_params) if authorize! :update, question
  end

  def destroy
    question.destroy if authorize! :update, question
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
      ApplicationController.render(
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
