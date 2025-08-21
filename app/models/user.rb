class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :bio, length: { maximum: 500 }

  has_one_attached :avatar
  has_many :rooms, dependent: :destroy 
  has_many :reservations       
end
