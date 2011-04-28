require "btjunkie/base"
module BtjunkieContainer
  class Torrent
    attr_accessor :details
    include BtjunkieContainer::Base
    
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
    
    # Is the torrent dead?
    # The definition of dead is; no seeders
    # Returns a boolean
    def dead?
      seeders <= 0
    end
    
    # Returns the amount of seeders for the current torrent
    # If the seeder-tag isn't found, the value one (1) will be returned.
    # Returns an integer from 0 to inf
    def seeders
      not_implemented
    end
    
    # Is the torrent valid?
    # The definition of valid:
    #   Non of the accessors
    #   => is nil
    #   => contains htmltags
    #   => starts or ends with whitespace
    # It must also stand up to the following requirements
    #   => The details and torrent url must be valid
    #   => The id for the torrent must only contain integers.
    # Returns {true} or {false}
    def valid?
      not_implemented
      # [:details, :torrent, :title, :id].each do |method|
      #     data = send(method)
      #     return false if send(method).nil? or 
      #       data.to_s.empty? or 
      #       data.to_s.match(/<\/?[^>]*>/) or 
      #       data.to_s.strip != data.to_s
      #   end
      #   
      #   !! valid_url?(details) and
      #   !! valid_torrent?(torrent) and
      #   !! inner_call(:id, details).to_s.match(/^\w+$/)
    end
    
    # Check to see if the ingoing param is a valid url or not
    def valid_url?(url)
      !! url.match(URI.regexp)
    end
    
    # Check to see if the ingoing param is a valid torrent url or not
    # The url has to be a valid url and has to end with .torrent
    def valid_torrent?(torrent)
      torrent.match(/\.torrent$/) and valid_url?(torrent)
    end
    
    # Generates an id using the details url
    def id
      @id ||= inner_call(:id, details).to_i
    end
    
    # Returns the domain for the torrent, without http or www
    # If the domain for some reason isn't found, it will use an empty string
    def domain
      @domain ||= details.match(/(ftp|http|https):\/\/([w]+\.)?(.+?\.[a-z]{2,3})/i).to_a[3] || ""
    end
    
    # Returns a unique id for the torrent based on the domain and the id of the torrent
    def tid
      @tid ||= Digest::MD5.hexdigest("#{domain}#{id}")
    end
    
    # Just a mirror method for {tid}, just in case someone don't like the method name tid
    def torrent_id
      @torrent_id ||= tid
    end
    
    # Returns the full url to the related imdb page
    # The link is parsed from the details view
    # Example: http://www.imdb.com/title/tt0066026
    # Return type: String or nil
    def imdb
      not_implemented
      # @imdb ||= content.to_s.match(/((http:\/\/)?([w]{3}\.)?imdb.com\/title\/tt\d+)/i).to_a[1]
    end
    
    # Returns the imdb id for the torrent, including the tt at the beginning
    # Example: tt0066026
    # Return type: String or nil
    def imdb_id
      not_implemented
      # @imdb_id ||= imdb.to_s.match(/(tt\d+)/).to_a[1]
    end
    
    # Returns an movie_searcher object based on the imdb_id, if it exists, otherwise the torrent title
    # Read more about it here: https://github.com/oleander/MovieSearcher
    # Return type: A MovieSearcher object or nil
    def movie
      not_implemented
      # imdb_id.nil? ? MovieSearcher.find_by_release_name(title, options: {
      #   details: true
      # }) : MovieSearcher.find_movie_by_id(imdb_id)
    end
    
    # Returns the title for the torrent
    # If the title has't been set from the Torrents class, we will download the details page try to find it there.
    # Return type: String or nil
    def title
      not_implemented
      #@title ||= inner_call(:details_title, content)
      #@title = @title.strip unless @title.nil?
    end
    
    # Returns a Undertexter object, if we found a imdb_id, otherwise nil
    # Read more about it here: https://github.com/oleander/Undertexter
    # Return type: A single Undertexter object or nil
    def subtitle(option = :english)
      # @subtitle = {} unless @subtitle
      # @subtitle[option] ||= Undertexter.find(imdb_id, language: option).based_on(title)
    end
    
    # Returns the torrent for the torrent
    # If the torrent has't been set from the Torrents class, we will download the details page try to find it there.
    # Return type: String or nil
    def torrent
      not_implemented
    end
  end
end