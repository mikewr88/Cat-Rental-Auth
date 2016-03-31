
class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true, uniqueness: true
  after_initialize :ensure_session_token
  validates :password, length: {minimum: 6, allow_nil: true}

  has_many :cats,
    foreign_key: :user_id,
    class_name: 'Cat'

  has_many :cat_rental_requests,
    foreign_key: :user_id,
    class_name: 'CatRentalRequest'

  def self.find_by_credentials(user_name, password)
    user = self.all.where(user_name: user_name).first
    return user if user.is_password?(password)
    nil
  end


  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    pw_check = BCrypt::Password.new(self.password_digest)
    pw_check.is_password?(pw)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)

  end



end
