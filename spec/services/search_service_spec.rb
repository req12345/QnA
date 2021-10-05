require 'rails_helper'

RSpec.describe SearchService do
  it 'executes method call' do
    SearchService.new(body: 'search object', type: 'Question').call
  end
end
