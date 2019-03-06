# User model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend Devise::Models
  has_one_time_password

  attr_writer :login
  attr_accessor :skip_password_validation
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[user admin superadmin] # 0-user, 1-admin, 2-superadmin
  enum status: %i[inactive active] # 0-inactive, 1-active

  has_many :user_otps, dependent: :destroy

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

  def email_required?
    !skip_password_validation
  end

  def password_required?
    if skip_password_validation
      false
    elsif new_record? 
      super
    elsif !new_record?
      false
    else
      true
    end
  end

  def login
    @login || self.mobile_number || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # rubocop:disable LineLength
      where(conditions).where(['lower(mobile_number) = :value OR lower(email) = :value', { value: login.downcase }]).first
      # rubocop:enable LineLength
    elsif conditions[:mobile_number].nil?
      where(conditions).first
    else
      where(mobile_number: conditions[:mobile_number]).first
    end
  end
end
