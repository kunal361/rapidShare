class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name
      t.string :description
      t.references :user
      t.timestamps
    end
    add_attachment :documents, :document
    add_index :documents, :document_file_name, :unique => true
  end

  def self.down
    drop_table :documents
  end
end
