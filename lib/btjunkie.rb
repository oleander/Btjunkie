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
    
  end
  
  def self.method_missing(meth, *args, &blk)
    Btjunkie.new.send(meth, *args, &blk)
  end
end
