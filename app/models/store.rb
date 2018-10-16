class Store < ActiveRecord::Base
  self.primary_key = :store_id

  has_many :food_images,   primary_key: 'store_id', foreign_key: 'store_id'
  has_many :users,         primary_key: 'store_id', foreign_key: 'store_id'
  has_many :reviews,       primary_key: 'store_id', foreign_key: 'store_id'
  has_many :input_reviews, primary_key: 'store_id', foreign_key: 'store_id'
end
