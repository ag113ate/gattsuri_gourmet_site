class CreateBookmarkStores < ActiveRecord::Migration
  def change
    create_table :bookmark_stores do |t|
      t.string :user_id
      t.string :store_id

      t.timestamps
    end
  end
end
