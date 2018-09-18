class FoodImage < ActiveRecord::Base
  belongs_to :store, foreign_key: 'store_id', primary_key: 'store_id'
end
