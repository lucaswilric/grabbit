
module UserHolderController
  def get_user   
    @user = User.find(session[:user_id]) if session[:user_id]
  end
end

