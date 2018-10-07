class CreateInputReviews < ActiveRecord::Migration
  def change
    create_table :input_reviews, id:false do |t|
      t.column :vote_id, 'INTEGER  PRIMARY KEY'
      t.string :menu_name
      t.text :comment
      t.float :total_score
      t.string :image
      t.string :change_name

      t.timestamps
    end
  end
end
