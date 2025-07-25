class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password

  enum gender: {male: 0, female: 1, other: 2}

  scope :recent, -> {order(created_at: :desc)}

  USER_PERMIT = %i(name email password password_confirmation date_of_birth
  gender).freeze

  VALID_EMAIL_REGEX = Regexp.new(Settings.development.user.valid_email_regex,
                                 Regexp::IGNORECASE)
  PASSWORD_REQUIREMENT =
    Regexp.new(Settings.development.user.password_requirement)

  validates :name, presence: true,
                  length: {maximum: Settings.development.user
                                            .max_name_length.to_i}
  validate :full_name_must_contain_first_and_last
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false},
            length: {maximum: Settings.development.user
                                      .max_email_length.to_i}
  validates :password, presence: true, length: {minimum: Settings
    .development.user.min_password_length.to_i},
            format: {with: PASSWORD_REQUIREMENT}, allow_nil: true
  validates :date_of_birth, presence: true
  validate :dob_validation
  validates :gender, presence: true

  before_save :downcase_email

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def dob_validation
    return unless date_of_birth

    current_date = Time.zone.today
    prev_date = current_date.prev_year(Settings.development.user.years.to_i)

    if date_of_birth > current_date
      errors.add(:date_of_birth, :greater_than_curdate)
    elsif date_of_birth < prev_date
      errors.add(:date_of_birth, :over_hundred_years)
    end
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def full_name_must_contain_first_and_last
    return if name.blank?

    return unless name.strip.split.size < 2

    errors.add(:name, :must_contain_first_and_last)
  end
end
