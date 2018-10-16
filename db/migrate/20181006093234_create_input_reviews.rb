class CreateInputReviews < ActiveRecord::Migration
  def change
    create_table :input_reviews, id:false do |t|
      t.integer :vote_id
      t.string :user_id
      t.string :store_id
      t.string :menu_name
      t.text :comment
      t.float :total_score
      t.string :image

      t.timestamps
    end
  end
end
