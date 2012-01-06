class DownloadJobAddSubscriptionProperly < ActiveRecord::Migration
  def up
    change_table :download_jobs do |t|
      t.references :subscription
    end
    
    remove_column :download_jobs, :subscriptions_id
  end

  def down
    remove_column :download_jobs, :subscription_id
  end
end
