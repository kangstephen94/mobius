class ApplicationMailer < ActionMailer::Base
  default from: 'skcoder94@gmail.com'

  def activation_email(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Mobius, please verify your account!")
  end
end