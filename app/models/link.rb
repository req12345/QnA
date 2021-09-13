class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: {
                    with: URI.regexp(%w[http https]),
                    message: 'is not a valid URL'
                  }
  def gist?
    URI(url).host.include?('gist')
  end

  def read_gist
    client = Octokit::Client.new
    client.gist(URI(url).path.split('/').last).files
  end
end
