class SearchService
  TYPES = %w[All Question Comment Answer User]

  def initialize(params)
    @type = params[:type]
    @body = params[:body]
  end

  def call
    return [] if @body.empty?
    @type == "All" ? ThinkingSphinx.search(@body) : Object.const_get(@type).search(@body)
  end
end
