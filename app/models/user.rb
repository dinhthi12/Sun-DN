class User < ApplicationRecord
  before_save ->{email.downcase!}

  validates :name, presence: true,
    length: {minimum: Settings.digits.length_10,
             maximum: Settings.digits.length_30}
  validates :email, presence: true, uniqueness: true,
    length: {minimum: Settings.digits.length_10,
             maximum: Settings.digits.length_30},
    format: {with: Settings.user.email.regex}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.min_length}

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
