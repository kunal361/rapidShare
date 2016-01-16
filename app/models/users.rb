require 'bcrypt'
class Users < ActiveRecord::Base
  include BCrypt
  has_many :documents
  def admin?
    self.role =='admin'
  end
end
