class Document < ActiveRecord::Base
  belongs_to :user
  has_attached_file :document, :path => "documents/:filename", :url => "document/:id"

  validates :description, :presence => true
  validates_attachment :document, :presence => true
  validates_attachment_file_name :document, :presence => true, :not => ""
  validates :user_id, :presence => true

  after_validation :add_hash_to_filename

  def add_hash_to_filename
    hash = DateTime.now.strftime("%Q")
    self.name = self.document_file_name
    self.document_file_name = "#{hash}_#{self.document_file_name}"
  end

end
