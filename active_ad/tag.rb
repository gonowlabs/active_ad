module ActiveAd
  class Tag
    attr_reader :name, :count
  
    def initialize(params = {})
      @name = params['name']
      @count = params['count']
    end
  
    def self.cloud
      response = Helper.get "advertises/tags"
      response.map { |item| new item['tag'] }
    end
  end
end
