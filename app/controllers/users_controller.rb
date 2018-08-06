class UsersController < ApplicationController
  def index 
    @users = User.all
    if current_user.nil?
      redirect_to new_session_url
    else 
      render :index
    end 
  end 

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      ApplicationMailer.activation_email(@user).deliver_now!
      flash[:notice] = 'Successfully created your account! Check your inbox for an activation email.'
      redirect_to new_session_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  # Custom route created for sending credits.
  # Transaction history is also taken care of in this route.

  def send_credits
    @users = User.all
    receiving_user = User.find(params[:id])
    amount_sent = user_params[:credit].to_i
    sending_updated_credits = current_user.credit - amount_sent
    receiving_updated_credits = receiving_user.credit + amount_sent
    if current_user.update_attributes(credit: sending_updated_credits)
      receiving_user.update_attributes(credit: receiving_updated_credits)
      @transaction = Transaction.create(from: current_user.id, to: params[:id], amount: amount_sent)
      flash[:notice] = "Sucessfully sent #{amount_sent} credits to #{receiving_user.email}"
      render :index
    else 
      flash[:errors] = ['Not enough credits, please add more']
      redirect_to users_url
    end 
  end 

  # Custom route created for sending authentication email.

  def activate
    @user = User.find_by(activation_token: params[:activation_token])
    @user.activate!
    login_user!(@user)
    flash[:notice] = 'Successfully activated your account!'
    redirect_to root_url
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :credit, :password_confirmation)
  end
end