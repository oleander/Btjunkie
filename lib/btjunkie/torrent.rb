require "digest/md5"

module BtjunkieContainer
  class Torrent
    attr_accessor :title, :torrent    
    def initialize(args)
      @subtitle = {}
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
    
    # Is the torrent dead?
    # The definition of dead is; no seeders
    # Returns a boolean
    def dead?
      seeders <= 0
    end
    
    def seeders
      @_seeders ||= @seeders.to_i
    end
    
    # Generates an id using the details url
    def id
      @id ||= torrent.match(/(\w+)\/download\.torrent$/)[1]
    end
    
    # Returns the domain for the torrent, without http or www
    # If the domain for some reason isn't found, it will use an empty string
    def domain
      "btjunkie.org"
    end
    
    # Returns a unique id for the torrent based on the domain and the id of the torrent
    def tid
      @tid ||= Digest::MD5.hexdigest("#{domain}#{id}")
    end
    
    # Just a mirror method for {tid}, just in case someone don't like the method name tid
    def torrent_id
      @torrent_id ||= tid
    end
    
    # Returns an movie_searcher object based on the imdb_id, if it exists, otherwise the torrent title
    # Read more about it here: https://github.com/oleander/MovieSearcher
    # Return type: A MovieSearcher object or nil
    def movie
      @_movie ||= MovieSearcher.find_by_release_name(title, options: {
        :details => true
      })
    end
    
    # Returns a Undertexter object, if we found a imdb_id, otherwise nil
    # Read more about it here: https://github.com/oleander/Undertexter
    # Return type: A single Undertexter object or nil
    def subtitle(option = :english)
      @subtitle[option] ||= Undertexter.find(movie.imdb_id, language: option).based_on(title)
    end
    
    def details
      "http://#{domain}#{@details}"
    end
    
    def imdb_id; nil; end
    
    alias_method :torrent_id, :id
  end
end