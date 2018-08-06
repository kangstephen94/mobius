class Api::DataController < ApplicationController

  ## api namespace custom route for sending back current_user email and credits
  
  def current_user_info 
    @user = current_user 
    if @user
      render 'api/data/show'
    else 
      render :json => {currentUser: 'There is no user logged in'}
    end 
  end 
end