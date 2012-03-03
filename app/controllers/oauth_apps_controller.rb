class OauthAppsController < ApplicationController
  def new
    @client = OAuth2::Model::Client.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @client }
    end
  end
  
  def create
    @client = OAuth2::Model::Client.new(params[:client])
    
    respond_to do |format|
      if @subscription.save
        format.html { render :action => "show" }
        format.json { render :json => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.json { render :json => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # I expect trouble here...
  def authorize
    @user  = User.find_by_id(session[:user_id])
    @oauth2 = OAuth2::Provider.parse(@user, request)

    if @oauth2.redirect?
      redirect_to @oauth2.redirect_uri, @oauth2.response_status
    end

    headers.push @oauth2.response_headers

    if @oauth2.response_body
      render :text => @oauth2.response_body, :status => @oauth2.response_status
    else
      render :controller => "sessions", :action => "new", :status => @oauth2.response_status
    end
  end
end
