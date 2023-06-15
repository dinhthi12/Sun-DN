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

  scope :sort_by_name, lambda {|direct, direct_email|
                         order(name: direct, email: direct_email)
                       }

  has_secure_password
end
