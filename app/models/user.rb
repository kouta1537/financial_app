class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true

  has_one_attached :avatar
  has_many :rooms, dependent: :destroy 
  has_many :reservations
  has_many :calculations
  
def self.guest
  find_or_create_by!(email: 'guest@example.com') do |user|
    user.password = SecureRandom.urlsafe_base64
    user.password_confirmation = user.password
    user.username = "ゲスト"
    user.confirmed_at = Time.current if user.respond_to?(:confirmed_at)
  end
end
end
