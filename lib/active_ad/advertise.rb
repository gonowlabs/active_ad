module ActiveAd
  class Advertise
    attr_accessor :attributes

    def initialize(params = {})
      @attributes = params.stringify_keys
    end

    def errors
      @errors ||= ActiveRecord::Errors.new nil
    end

    def avatar(size = :default)
      @attributes['avatar_urls'][size.to_s]
    end

    def comments
      []
    end

    def id
      @attributes['id']
    end

    def new_record?
      id.nil?
    end

    def update_attributes(attributes_to_update)
      attributes_to_update[:id] = id
      response = Helper.put "advertises/#{id}", :advertise => attributes_to_update
      true
    end

    def save
      response = Helper.post "advertises", :advertise => @attributes
      @attributes['id'] = response['advertise']['id']
      true
    end

    def to_param
      id.to_s
    end

    def tag_list
      tags = @attributes['tags']
      tags.map { |item| item['tag']['name'] }.join(",") if tags
    end

    def tags
      @attributes['tags'].map { |item| Tag.new(item['tag']) }
    end

    def dynamic_attributes
      dynamic_attributes = @attributes['dynamic_attributes'] || Array.new(2, {})
      dynamic_attributes.map { |params| Attribute.new params.symbolize_keys }
    end

    def dynamic_attributes_attributes=(param)
    end

    def attachments
      @attributes['attachments_urls']
    end

    def owner
      owner_id = @attributes['owner_id']
      User.find(owner_id) unless owner_id.nil?
    end

    def description
      @attributes['description']
    end

    def price
      @attributes['price']
    end

    def title
      @attributes['title']
    end

    def hits
      @attributes['hits']
    end

    def self.find(id)
      response = Helper.get "advertises/#{id}"
      new response['advertise']
    end

    def self.find_by_attribute(attribute, value)
      advertises = []
      response = Helper.get "find_by_attribute/#{attribute}/#{value}"
      response.each do |advertise|
        advertises << (new advertise['advertise'])
      end
      advertises
    end

    def self.find_by_owner_id(id)
      search "owner_id:#{id}"
    end

    def self.human_name(locale = '')
      I18n.t :'active_ad.advertise'
    end

    def self.create!(params)
      advertise = new(params)
      advertise.save
      advertise
    end

    def self.search(query, params = {})
      query.gsub! '/', ' '
      data =  params[:page] ? "page=#{params[:page]}" : nil
      SearchResult.new Helper.get("search/#{query}", data)['search_result']
    end

    def self.latests
      response = Helper.get "advertises/latests"
      response.map { |ad| new ad['advertise'] }
    end

    def destroy
      Helper.delete "advertises/#{id}"
    end
  end
end

