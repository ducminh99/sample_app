class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content picture).freeze
  
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_content_length}
  validate :picture_size

  scope :order_desc, ->{order(created_at: :desc)}

  delegate :name, to: :user, prefix: true

  private

  def picture_size
    if picture.size > Settings.micropost.max_picture_size.megabytes
      flash[:danger] = t "microposts.picture_size_warning"
      redirect_to root_path
    end
  end
end
