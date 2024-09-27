class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # :confirmable,
         :omniauthable

  # Association with projects
  has_many :projects, dependent: :destroy

  # Set the user as an admin
  def set_admin
    update(admin: true)
  end

  # Remove admin privileges from the user
  def remove_admin
    update(admin: false)
  end
end
