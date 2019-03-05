# User model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[user admin superadmin] # 0-user, 1-admin, 2-superadmin
  enum status: %i[inactive active] # 0-inactive, 1-active

  scope :active, -> { where(status: 1, deleted_at: nil).where.not(role: :superadmin) }
  scope :inactive_users, -> { where(status: 0, deleted_at: nil).where.not(role: :superadmin) }
  scope :deleted_users, -> { where.not(deleted_at: nil).where.not(role: :superadmin) }

  validates :first_name, presence: true

  def name
    first_name.present? && last_name.present? ? "#{first_name} #{last_name}" : 'User Name'
  end

  def self.user_create(params)
    user = User.new(params)
    user.save
    user
  end

  def user_update(params)
    update_attributes(params)
  end
end
