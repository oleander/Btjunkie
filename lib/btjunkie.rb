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
  
  def find_by_details(url)
    doc = content(url)
    BtjunkieContainer::Torrent.new({
      :torrent => doc.to_s.match(/(http.+?\.torrent)/i).to_a[1],
      :details => url.to_s.gsub("http://btjunkie.org", ""),
      :title   => doc.at_css(".Wht font").content.strip,
      :seeders => doc.at_css("#main").to_s.match(/([^>][\d,]+) seeds/).to_a[1].to_s.gsub(/[^\d]+/, "")
    })
  end
  
  private
    def scrape
      if @url.nil?
        raise ArgumentError.new "You need to specify a category"
      elsif @cookies.nil?
        raise ArgumentError.new "You need to specify a cookie using #cookies"
      end
        
      content(url).css("table.tab_results tr").reject do |tr| 
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
    
    def download(url)
      @_download ||= RestClient.get(url, :timeout => 10)
    end

    def content(url)
      @_content ||= Nokogiri::HTML(download(url))
    end
end
