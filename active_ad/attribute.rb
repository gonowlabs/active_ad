module ActiveAd
  class Attribute
    def initialize(params = {})
      @attributes = params
    end

    def name
      @attributes[:name]
    end

    def value
      @attributes[:value]
    end

    def new_record?
      true
    end

    def self.suggest(tags)
      response = Helper.get "suggest/attributes/#{tags}"
      response.map { |item| new :name => item.first }
    end
  end
end
