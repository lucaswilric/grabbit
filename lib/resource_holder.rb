module ResourceHolder
  def url
    self.resource.url if self.resource
  end
  
  def url=(value)
    self.resource = Resource.find_by_url(value) || Resource.new(:url => value)
    
    self.resource.save
    
    self.url
  end
end
