module ActiveAd
  class Query
    attr_reader :name, :count, :results_count

    def initialize(params = {})
      @name = params['name']
      @count = params['count']
      @results_count = params['results_count']
    end

    def self.suggest(query)
      response = Helper.get "suggest/queries/#{query}"
      response['search_result']['queries'].map { |query| new query }
    end
  end
end
