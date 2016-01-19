class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name
      t.string :description
      t.string :path
      t.references :user
      t.timestamps
    end
    add_index :documents, :name, :unique => true
  end

  def self.down
    drop_table :documents
  end
end
