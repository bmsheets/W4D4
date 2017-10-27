class User < ApplicationRecord
  validates :user_name, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  validates :password_digest, presence: { message: "password can't be blank"}
  validates :password, length: { minimum: 6 }, allow_nil: true
  after_initialize :ensure_session_token

  attr_reader :password

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
    self.save
  end

  def is_password?(password)
    pass_hash = BCrypt::Password.new(self.password_digest)
    pass_hash.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
    # self.session_token = SecureRandom::urlsafe_base64(16) if self.session_token.nil?
    #
    # if self.session_token.nil?
    #   return
    # else
    #   self.session_token = SecureRandom::urlsafe_base64(16)
    # end

  end
end
