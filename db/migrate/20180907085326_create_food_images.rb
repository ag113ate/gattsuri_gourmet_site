class CreateFoodImages < ActiveRecord::Migration
  def change
    create_table :food_images, id: false do |t|
      t.column :store_id, 'STRING PRIMARY KEY'
      t.string :image_url

      t.timestamps
    end
  end
end
