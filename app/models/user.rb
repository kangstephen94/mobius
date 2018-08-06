# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  email            :string           not null
#  password_digest  :string           not null
#  session_token    :string           not null
#  activated        :boolean          default(FALSE), not null
#  activation_token :string           not null
#  credit           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class User < ApplicationRecord

  before_save :email_downcase

  validates :activation_token, :email, :session_token, uniqueness: true
  validates :credit, numericality: { greater_than_or_equal_to: 0 }
  PASSWORD_FORMAT = /\A
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
 /x

  # Included two validations for password because one is applied when a user creates an account,
  # and the other for when a user logs in.

  validates :password, presence: true, length: { minimum: 6, allow_nil: true }, confirmation: { case_sensitive: true }, format: { with: PASSWORD_FORMAT }, on: :create
  validates :password, length: { minimum: 6, allow_nil: true }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password_digest, :session_token, :activation_token, presence: true

  attr_reader :password

  after_initialize :ensure_session_token
  after_initialize :set_activation_token
  

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)

    user && user.is_password?(password) ? user : nil
  end

  def set_activation_token
    self.activation_token = generate_unique_activation_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!

    self.session_token
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end

  def generate_unique_session_token
    token = SecureRandom.urlsafe_base64(16)

    ##
    # Just in case there is a session_token conflict, make sure
    # not to throw a validation error at the user
    ##

    while self.class.exists?(session_token: token)
      token = SecureRandom.urlsafe_base64(16)
    end

    token
  end

  ##
  # These methods are for the mailer
  ##
  def generate_unique_activation_token
    token = SecureRandom.urlsafe_base64(16)
    while self.class.exists?(activation_token: token)
      token = SecureRandom.urlsafe_base64(16)
    end
    token
  end

  def activate!
    self.update_attribute(:activated, true)
  end

  def email_downcase
    self.email = email.downcase
  end
end
