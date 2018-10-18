class CreateSubCities < ActiveRecord::Migration
  def change
    create_table :sub_cities do |t|
      t.integer :city_id
      t.string :sub_city_name

      t.timestamps null: false
    end
  end
end
