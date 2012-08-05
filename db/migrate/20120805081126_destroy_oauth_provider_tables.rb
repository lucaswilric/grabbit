class DestroyOauthProviderTables < ActiveRecord::Migration
  def up
    OAuth2::Model::Schema.down
  end

  def down
    OAuth2::Model::Schema.up
  end
end
