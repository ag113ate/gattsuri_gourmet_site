class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores, id:false do |t|
      t.column :store_id, 'STRING PRIMARY KEY'
      t.string :name
      t.float :review
      t.string :opentime
      t.string :holiday
      t.string :tel
      t.string :address
      t.string :line
      t.string :station
      t.string :station_exit
      t.integer :walk
      t.float :latitude
      t.float :longitude
      t.string :category_name_l
      t.string :shop_url

      t.timestamps
    end
  end
end
