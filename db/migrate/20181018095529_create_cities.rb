class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :pref_code
      t.string :pref_name
      t.string :city_name
      t.binary :is_designated_cities

      t.timestamps null: false
    end
  end
end
