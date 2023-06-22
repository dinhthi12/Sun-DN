class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :newest, ->{order created_at: :desc}

  validates :content, presence: true,
                      length: {maximum: Settings.digits.length_30}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png)},
                    size: {less_than: Settings.micropost.image_max_5MB}

  def display_image
    image.variant resize_to_limit: [Settings.micropost.image_200,
      Settings.micropost.image_200]
  end
end
