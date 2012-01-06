class SubscriptionChangeUrlXpath < ActiveRecord::Migration
  def up
    rename_column :subscriptions, :url_xpath, :url_element
  end

  def down
    rename_column :subscriptions, :url_element, :url_xpath
  end
end
