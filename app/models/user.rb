class User < ActiveRecord::Base
  has_secure_password
  has_many :documents

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness =>true
  validates :password, :presence => true, :length => { :minimum => 6 , :maximum => 20}

  def admin?
    self.role =='admin'
  end

  def change_role(user_id, role)
    user = User.where(:id => user_id)
    if user.empty?
      return false
    end
    user.first.update_attribute(:role, role)
    return true
  end

end
