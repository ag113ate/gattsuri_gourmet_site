class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews, id:false do |t|
      t.integer :vote_id
      t.string :user_id
      t.string :store_id
      t.string :menu_name
      t.text :comment
      t.float :total_score
      t.datetime :update_date

      t.timestamps
    end
  end
end
