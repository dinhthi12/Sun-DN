class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest
  before_save ->{email.downcase!}

  validates :name, presence: true,
    length: {minimum: Settings.digits.length_4,
             maximum: Settings.digits.length_30}
  validates :email, presence: true, uniqueness: true,
    length: {minimum: Settings.digits.length_4,
             maximum: Settings.digits.length_30},
    format: {with: Settings.user.email.regex}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.min_length},
    allow_nil: true

  scope :sort_by_name, lambda {|direct, direct_email|
                         order(name: direct, email: direct_email)
                       }

  has_secure_password

  def password_reset_expired?
    reset_sent_at < Settings.digits.expired_2.hours.ago
  end

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
end
