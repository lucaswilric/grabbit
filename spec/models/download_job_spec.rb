require 'spec_helper'

describe DownloadJob do

  before :each do
    DownloadJob.delete_all
    Subscription.delete_all
  end

  context 'when creating' do
    it 'does not save if a pending download already exists for its URL' do
      DownloadJob.create({
        :url => "abc"
      })
      
      DownloadJob.create({
        :url => "abc"
      }).should have(1).errors_on(:base)
    end
    
    it 'sets the status to "Not Started"' do
      dj = DownloadJob.create({
        :url => "def"
      })
      dj.status.should == "Not Started"
    end
    
    it 'saves with all the tags that its subscription has' do
      sub = Subscription.create
      sub.tag_names = 'jimmy,johnny,jack'
      sub.save
      dj = DownloadJob.create({
        :subscription => sub,
        :url => "ghi"
      })
      dj.tags.should have(3).things
    end
  end
  
  context 'when finding by tag' do
    it 'gives back all the download jobs with the given tag' do
      dj1 = DownloadJob.create({
        :url => 'dj1',
        :tag_names => 'a,b'
      })
      dj2 = DownloadJob.create({
        :url => 'dj2',
        :tag_names => 'b,c'
      })
      dj3 = DownloadJob.create({
        :url => 'dj3',
        :tag_names => 'a,c'
      })
      
      tagged_b = DownloadJob.find_by_tag 'b'
      
      tagged_b.should include dj1
      tagged_b.should include dj2
    end
    
    it 'gives back no download jobs lacking the given tag' do
      dj1 = DownloadJob.create({
        :url => 'dj1',
        :tag_names => 'a,b'
      })
      dj2 = DownloadJob.create({
        :url => 'dj2',
        :tag_names => 'b,c'
      })
      dj3 = DownloadJob.create({
        :url => 'dj3',
        :tag_names => 'a,c'
      })
      
      tagged_b = DownloadJob.find_by_tag 'b'
      
      tagged_b.should_not include dj3
    end
  end
end
