class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = Regexp.new(Settings.development.user.valid_email_regex,
                                 Regexp::IGNORECASE)
  PASSWORD_REQUIREMENT =
    Regexp.new(Settings.development.user.password_requirement)

  validates :name, presence: true,
                  length: {maximum: Settings.development.user
                                            .max_name_length.to_i,
                           message: :too_short}
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false},
                    length: {maximum: Settings.development.user
                                              .max_email_length.to_i}
  validates :password, length: {minimum: Settings
    .development.user.min_password_length.to_i},
            format: {with: PASSWORD_REQUIREMENT,
                     message: :password_requirement_message},
            if: ->{new_record? || !password_digest.nil?}
  validates :date_of_birth, presence: true
  validate :dob_validation

  before_save :downcase_email

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
end
