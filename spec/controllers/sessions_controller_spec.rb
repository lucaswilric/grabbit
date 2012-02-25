require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      post 'create', :provider => 'open_id'
      response.should be_redirect
    end
  end

  describe "GET 'failure'" do
    it "returns http success" do
      get 'failure'
      response.should be_success
    end
  end
  
  describe "GET 'destroy'" do
    it "returns http success" do
      post 'destroy'
      response.should be_redirect
    end
  end

end
