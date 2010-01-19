module ActiveAd
  class Facet
    attr_reader :name, :count

    def initialize(params = {})
      @name = params[:name]
      @count = params[:count].to_i
    end

    def self.from_hash(hash)
      search = hash.map { |value, count| Facet.new :name => value, :count => count }
      search.sort! {|a,b| (a.count <=> b.count)*-1 }
    end
  end
end
