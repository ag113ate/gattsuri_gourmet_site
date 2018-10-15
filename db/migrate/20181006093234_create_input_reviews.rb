class CreateInputReviews < ActiveRecord::Migration
  def change
    create_table :input_reviews, {id:false, primary_key: :vote_id} do |t|
      t.integer :vote_id
      t.string :menu_name
      t.text :comment
      t.float :total_score
      t.string :image
      t.string :change_name

      t.timestamps
    end
  end
end
