class User < ActiveRecord::Base
  has_secure_password
  has_many :adds
  has_many :songs, through: :adds

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i    

  validates :first_name, :last_name, presence: true , length:{minimum: 2}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  validates :password, length: {minimum: 7}

  before_save :set_case  

  private
  def set_case
    self.email.downcase!
  end
end
