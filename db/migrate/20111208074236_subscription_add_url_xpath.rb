class SubscriptionAddUrlXpath < ActiveRecord::Migration
  def up
    change_table :subscriptions do |t|
      t.string :url_xpath
    end
  end

  def down
    remove_column :subscriptions, :url_xpath
  end
end
