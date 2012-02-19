require 'spec_helper'

describe Subscription do
  before :each do
    Subscription.delete_all
  end

  context 'when finding by tag' do
    it 'gives back all the subscriptions with the given tag' do
      s1 = Subscription.create({
        :tag_names => 'a,b'
      })
      s2 = Subscription.create({
        :tag_names => 'b,c'
      })
      s3 = Subscription.create({
        :tag_names => 'a,c'
      })
      
      tagged_b = Subscription.find_by_tag 'b'
      
      tagged_b.should include s1
      tagged_b.should include s2
    end
    
    it 'gives back no subscriptions lacking the given tag' do
      s1 = Subscription.create({
        :tag_names => 'a,b'
      })
      s2 = Subscription.create({
        :tag_names => 'b,c'
      })
      s3 = Subscription.create({
        :tag_names => 'a,c'
      })
      
      tagged_b = Subscription.find_by_tag 'b'
      
      tagged_b.should_not include s3
    end
  end

end
