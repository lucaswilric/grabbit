class DownloadJobAddSubscription < ActiveRecord::Migration
  def up
    change_table :download_jobs do |t|
      t.references :subscriptions
    end
  end

  def down
    remove_column :download_jobs, :subscriptions_id
  end
end
