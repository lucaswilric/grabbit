class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :title
      t.string :url
      t.string :status
      t.string :directory

      t.timestamps
    end
  end
end
