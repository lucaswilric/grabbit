class SubscriptionAddTags < ActiveRecord::Migration
  def up
    create_table :subscriptions_tags, :id => false do |t|
      t.references :subscription, :tag
    end
  end

  def down
    drop_table :subscriptions_tags
  end
end
