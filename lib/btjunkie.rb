require "rest-client"
require "nokogiri"

class Btjunkie  
  def initialize
    @page = 1
  end
  
  def page(page)
    tap { @page = page }
  end
  
  def cookies(cookies)
    tap { @cookies = cookies }
  end
  
  def movies
    tap { @url = "http://btjunkie.org/browse/Video?o=72&t=0&p=<PAGE>" }
  end
  
  def torrents
    @_torrents ||= scrape
  end
  
  def self.method_missing(meth, *args, &blk)
    Btjunkie.new.send(meth, *args, &blk)
  end
  
  private
    def scrape
      download
    end
    
    def content
      @_content ||= Nokogiri::HTML(download)
    end
  
    def download
      if @url.nil?
        raise ArgumentError.new "You need to specify a category"
      elsif @cookies.nil?
        raise ArgumentError.new "You need to specify a cookie using #cookies"
      end
      
      @_download ||= RestClient.get(@url, :timeout => 10)
    end
end
