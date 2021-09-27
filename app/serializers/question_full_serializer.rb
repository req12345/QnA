class QuestionFullSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at

  has_many :answers
  has_many :comments
  has_many :links
  has_many :files
  
  def answers
    object.comments.map(&:body)
  end

  def comments
    object.comments.map(&:body)
  end

  def links
    object.links.map(&:url)
  end

  def files
     object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
