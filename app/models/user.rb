class User < ActiveRecord::Base
  has_secure_password
  has_many :documents

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness =>true
  validates :password, :presence => true, :length => { :minimum => 6 , :maximum => 20}

  def admin?
    self.role =='admin'
  end

  def change_role(role)
    self.update_attribute(:role, role)
  end

end
