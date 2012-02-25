class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
 
    if auth_hash
      @user = User.find_by_open_id(auth_hash['uid'])
    
      if @user
        session[:user_id] = @user.id
      
        redirect_to subscriptions_url, :notice => "Hi #{@user.name || 'there'}!"
      else
        render :text => "Sorry, you're not known here. Contact the owner of the server to arrange an account."
      end
    else
      redirect_to 'failure'
    end
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/', :notice => "You've logged out!"
  end
end
