class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews, id:false do |t|
      t.column :vote_id, 'INTEGER PRIMARY KEY'
      t.string :user_id
      t.string :store_id
      t.text :comment
      t.float :total_score

      t.timestamps
    end
  end
end
