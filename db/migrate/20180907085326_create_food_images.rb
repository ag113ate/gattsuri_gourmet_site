class CreateFoodImages < ActiveRecord::Migration
  def change
    create_table :food_images do |t|
      t.string :store_id
      t.string :image_url

      t.timestamps
    end
  end
end
