class Btjunkie  
  def page(page)
    tap { @page = page }
  end
  
  def self.method_missing(meth, *args, &blk)
    Btjunkie.new.send(meth, *args, &blk)
  end
end
