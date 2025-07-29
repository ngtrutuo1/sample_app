class Micropost < ApplicationRecord
  MICROPOST_PERMIT = %i(image content).freeze
  IMAGE_ALLOWED_TYPE = %w(image/jpeg image/png image/gif).freeze

  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [
                         Settings.development.microposts.image.thumb_height,
                         Settings.development.microposts.image.thumb_width
                       ]
  end

  scope :recent, -> {order(created_at: :desc)}

  validates :content, presence: true,
              length: {maximum: Settings.development.microposts.max_length}
  validates :image,
            content_type: {
              in: IMAGE_ALLOWED_TYPE,
              message: :must_be_a_valid_image_format
            },
                size: {less_than:
                          Settings.development.microposts.max_size.megabytes,
                       message: :image_too_big}
end
