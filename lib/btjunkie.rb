class Btjunkie  
  def initialize
    @page = 1
  end
  
  def page(page)
    tap { @page = page }
  end
  
  def step
    tap { @step = true }
  end
  
  def movies
    @page += 1 if @step
  end
  
  def self.method_missing(meth, *args, &blk)
    Btjunkie.new.send(meth, *args, &blk)
  end
end
