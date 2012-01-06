module TagHolder
  def tag_names
    names = ""

    tags.each do |tag|
      names << tag.name + ", "
    end

    names[0..names.length-3]
  end

  def tag_names=(tag_names)
    self.tags = []
  
    tag_names.split(%r{,\s*}).each do |name|
      tag = Tag.find_by_name name
      
      tag = Tag.create(:name => name) if tag == nil

      self.tags << tag unless self.tags.include? tag
    end
  end

  def add_tags(new_tags = [])
    new_tags.each do |t|
      self.tags << t unless self.tags.include? t
    end
  end
end
