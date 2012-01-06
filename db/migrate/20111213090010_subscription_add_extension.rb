class SubscriptionAddExtension < ActiveRecord::Migration
  def up
    change_table :subscriptions do |t|
      t.string :extension
    end
  end

  def down
    remove_column :subscriptions, :extension
  end
end
