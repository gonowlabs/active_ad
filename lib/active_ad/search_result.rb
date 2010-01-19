module ActiveAd
  class SearchResult < Array
    attr_reader :facets, :page, :total_pages, :count

    def initialize(result)
      super result['advertises'].map { |ad| Advertise.new ad }
      @facets = {}
      result['facets'].each do |attribute, values|
        @facets[attribute] = Facet.from_hash values
      end
      @page = result['page']
      @total_pages = result['total_pages']
      @count = result['count']
    end
  end
end
