class Document < ActiveRecord::Base
  before_validation :set_params
  belongs_to :user
  validates :description, :presence => true
  validates :name, :presence => true, :uniqueness =>true
  validates :path, :presence => true
  validates :user_id, :presence => true

  def set_params
    return false if self.path.nil?
    document = self.path
    self.name = File.basename(document.original_filename)
    dir = "documents/"
    Dir.mkdir(dir) unless File.exists?(dir)
    self.path = File.join(dir, name)
    return true
  end

end
