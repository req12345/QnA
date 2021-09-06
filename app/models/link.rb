class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: {
                    with: URI.regexp(%w[http https]),
                    message: 'is not a valid URL'
                  }
end
