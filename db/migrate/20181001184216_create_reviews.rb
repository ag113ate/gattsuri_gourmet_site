class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews, id:false do |t|
      t.column :vote_id, 'INTEGER PRIMARY KEY'
      t.string :user_id
      t.string :store_id
      t.string :menu_name
      t.string :comment
      t.float :total_score
      t.datetime :update_data

      t.timestamps
    end
  end
end
