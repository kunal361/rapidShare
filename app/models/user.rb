require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt
  has_many :documents
  def admin?
    self.role =='admin'
  end
end
