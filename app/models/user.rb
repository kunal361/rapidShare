class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  has_many :documents

  validates :name, :presence => true

  def admin?
    self.role =='admin'
  end

  def change_role(role)
    self.update_attribute(:role, role)
    return true
  end

end
