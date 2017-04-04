class PictureProduct < ApplicationRecord
  belongs_to :product
  has_attached_file :image, styles: {small: Settings.small,
    medium: Settings.medium, large: Settings.large}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
