class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :show, :update, :destroy ]
  before_action :find_answer, only: [ :show, :update, :destroy ]

  def index
    @question = Question.includes(:answers)
    render json: @question
  end

  def show
    render json: @answer, serializer: AnswerFullSerializer
  end

  def create

    @answer = @question.answers.create(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer

    if @answer.update(question_params)
      render json: @answer, status: :accepted
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer

    @answer.destroy
    render json: { messages: ['Your answer deleted'] }
  end
  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
