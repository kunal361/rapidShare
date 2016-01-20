class Document < ActiveRecord::Base
  belongs_to :user

  before_validation :set_params
  after_save :upload
  after_destroy :delete_document

  validates :description, :presence => true
  validates :name, :presence => true
  validates :path, :presence => true, :uniqueness =>true
  validates :user_id, :presence => true

  private

  def set_params
    return false if self.path.nil?
    @document = self.path
    self.name = File.basename(@document.original_filename)
    hash = DateTime.now.strftime("%Q")
    hashed_name = "#{hash}_#{self.name}"
    dir = "documents/"
    Dir.mkdir(dir) unless File.exists?(dir)
    self.path = File.join(dir, hashed_name)
  end

  def upload
    File.open(self.path, "wb") { |f| f.write(@document.read) }
  end

  def delete_document
    File.delete(self.path) if File.exists?(self.path)
  end

end
