module BtjunkieContainer
  module Base
    def download
      @_download ||= RestClient.get(url, :timeout => 10)
    end
    
    def content
      @_content ||= Nokogiri::HTML(download)
    end
    
    def url
      not_implemented
    end
  end
end