class Store < ActiveRecord::Base
  has_many :food_images, primary_key: 'store_id', foreign_key: 'store_id'
  
  has_many :users, primary_key: 'store_id', foreign_key: 'store_id'
end
