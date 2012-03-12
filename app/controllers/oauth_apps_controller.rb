class OauthAppsController < ApplicationController
  include UserHolderController
  
  before_filter :login_required
  before_filter :get_user
  
  def login_required
    redirect_to subscriptions_url unless session[:user_id]
  end
  
  def new
    @client = OAuth2::Model::Client.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @client }
    end
  end
  
  def create
    @client = OAuth2::Model::Client.new(params[:o_auth2_model_client])
    
    respond_to do |format|
      if @client.save
        format.html { render :action => "show" }
        format.json { render :json => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.json { render :json => @client.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def authorize
    @oauth2 = OAuth2::Provider.parse(@user, request, client_params)
    
    if @oauth2.redirect?
      redirect_to @oauth2.redirect_uri, :status => @oauth2.response_status
      return
    end

    headers.merge @oauth2.response_headers

    if @oauth2.response_body
      render :text => @oauth2.response_body, :status => @oauth2.response_status
    else
      render :action => "authorize", :status => @oauth2.response_status
    end
  end
  
  def allow
		oauth_params = params.merge client_params
		
		@auth = OAuth2::Provider::Authorization.new(@user, oauth_params)
	
		@auth.grant_access!

		redirect_to @auth.redirect_uri, :status => @auth.response_status
  end
  
  private
  
  def client_params
  	client_id = params['oauth_consumer_key'] || params['client_id']
		@client = OAuth2::Model::Client.find_by_client_id(client_id)
    
  	{'client_id' => @client.client_id, 'redirect_uri' => @client.redirect_uri, 'response_type' => 'code_and_token'}
  end
end
