class AddCountToUserStocks < ActiveRecord::Migration
  def change
    add_column :user_stocks, :count, :integer, default: 0
  end
end
