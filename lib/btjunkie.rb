require "rest-client"
require "nokogiri"
require "abstract"
require "btjunkie/torrent"
require "movie_searcher"
require "undertexter"

class Btjunkie  
  def initialize
    @page = 1
    @categories = {
      :movies => "http://btjunkie.org/browse/Video?o=72&t=1&s=1&p=<PAGE>"
    }
  end
  
  def page(page)
    tap { @page = page }
  end
  
  def cookies(cookies)
    tap { @cookies = cookies }
  end
  
  def category(what)
    tap { @url = @categories[what] }
  end
  
  def results
    @_torrents ||= scrape
  end
  
  def self.method_missing(meth, *args, &blk)
    Btjunkie.new.send(meth, *args, &blk)
  end
  
  private
    def scrape
      if @url.nil?
        raise ArgumentError.new "You need to specify a category"
      elsif @cookies.nil?
        raise ArgumentError.new "You need to specify a cookie using #cookies"
      end
        
      content.css("table.tab_results tr").reject do |tr| 
        tr.at_css("th.label").nil? or
        tr.at_css("font[color='#32CD32']").nil?
      end.map do |tr|
        a = tr.css("a"); 
        BtjunkieContainer::Torrent.new({
          :torrent => a[0].attr("href"),
          :details => a[2].attr("href"),
          :title   => a[2].content,
          :seeders => tr.at_css("font[color='#32CD32']").text
        })
      end
    end
  
    def url
      @_url ||= @url.gsub("<PAGE>", @page.to_s)
    end
    
    def download
      @_download ||= RestClient.get(url, :timeout => 10)
    end

    def content
      @_content ||= Nokogiri::HTML(download)
    end
end
