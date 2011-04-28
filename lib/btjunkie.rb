require "rest-client"
require "nokogiri"

class Btjunkie  
  def initialize
    @page = 1
    @categories = {
      :movies => "http://btjunkie.org/browse/Video?o=72&t=0&s=1&p=<PAGE>"
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
  
  def torrents
    @_torrents ||= scrape
  end
  
  def self.method_missing(meth, *args, &blk)
    Btjunkie.new.send(meth, *args, &blk)
  end
  
  private
    def scrape
      content.css("table.tab_results tr").reject do |tr| 
        tr.at_css("th.label").nil? or
        tr.at_css("font[color='#32CD32']").nil?
      end.map do |tr|
        a = tr.css("a")
        {
          torrent: a[0].attr("href"),
          details: a[2].attr("href"),
          title: a[2].content,
          seeders: tr.at_css("font[color='#32CD32']").text
        }
      end
    end
    
    def content
      @_content ||= Nokogiri::HTML(download)
    end
  
    def url
      @_url ||= @url.gsub("<PAGE>", @page.to_s)
    end
    
    def download
      if @url.nil?
        raise ArgumentError.new "You need to specify a category"
      elsif @cookies.nil?
        raise ArgumentError.new "You need to specify a cookie using #cookies"
      end
      
      @_download ||= RestClient.get(url, :timeout => 10)
    end
end
