class SessionsController < ApplicationController

  def new
    if logged_in?
      redirect_to root_url  # Restrict access to /session/new if the user is logged in.
    else 
      render :new
    end 
  end

  def create
    user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if user.nil?
      flash.now[:errors] = ["Invalid credentials."]
      render :new

    # We're able to use User#activated? because Rails gives this method for free because it matches a column name.
  
    elsif !user.activated?
      flash.now[:errors] = ['You must activate your account first! Check your email.']
      render :new
    else
      login_user!(user)
      redirect_to root_url
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil

    redirect_to new_session_url
  end
end