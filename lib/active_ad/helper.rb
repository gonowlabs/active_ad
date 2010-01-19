module ActiveAd

  CONFIG = YAML.load_file("#{RAILS_ROOT}/config/active_ad.yml")[RAILS_ENV]
  HOST = CONFIG['host']
  TOKEN = CONFIG['token']

  module Helper
    def self.post(path, attributes)
      params_from HTTPClient.post(path_for(path), to_params(attributes)).body.content
    end

    def self.get(path, query = nil)
      url = path_for(escape(path))
      url += "?#{query}" if query
      params_from HTTPClient.get(url).body.content
    end

    def self.put(path, attributes)
      attributes["_method"] = "put"
      params_from HTTPClient.post(path_for(path), to_params(attributes)).body.content
    end

    def self.delete(path)
      HTTPClient.delete(path_for(path))
    end

    def self.path_for(path)
      "#{HOST}/business_owners/#{TOKEN}/#{path}.json"
    end

    def self.params_from(string)
      ActiveSupport::JSON.decode string
    end

    def self.full_url_for(path)
      "#{HOST}#{path}"
    end

    private

    def self.escape(path)
      URI.encode path
    end

    def self.process(p=nil, parent_key=nil)
      p.keys.map do |k|
		    key = parent_key ? "#{parent_key}[#{k}]" : k
		    if p[k].is_a? Hash
			    process(p[k], key)
		    else
			    { key => value_for(p[k]) }
		    end
	    end
    end

    def self.to_params(hash)
      params = {}
      process(hash).flatten.each { |item| params[item.keys.first] = item.values.first }
      params
    end

    def self.value_for(value)
      if value.instance_of?(File) or value.instance_of?(::Tempfile)
        value
      else
        URI.escape value.to_s
      end
    end
  end
end
