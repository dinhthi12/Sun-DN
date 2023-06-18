class User < ApplicationRecord
  attr_accessor :remember_token

  before_save ->{email.downcase!}

  validates :name, presence: true,
    length: {minimum: Settings.digits.length_10,
             maximum: Settings.digits.length_30}
  validates :email, presence: true, uniqueness: true,
    length: {minimum: Settings.digits.length_10,
             maximum: Settings.digits.length_30},
    format: {with: Settings.user.email.regex}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.min_length},
    allow_nil: true

  scope :sort_by_name, lambda {|direct, direct_email|
                         order(name: direct, email: direct_email)
                       }

  has_secure_password

  class << self
    def digest string
      min_cost = BCrypt::Engine::MIN_COST
      default_cost = BCrypt::Engine.cost
      cost = ActiveModel::SecurePassword.min_cost ? min_cost : default_cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end
end
