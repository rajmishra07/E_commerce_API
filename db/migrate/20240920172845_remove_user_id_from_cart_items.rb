class RemoveUserIdFromCartItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :cart_items, :user_id, :integer
  end
end
