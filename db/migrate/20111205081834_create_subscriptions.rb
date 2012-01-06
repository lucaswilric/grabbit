class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :title
      t.string :destination
      t.references :resource

      t.timestamps
    end
    add_index :subscriptions, :resource_id
  end
end
