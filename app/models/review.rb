class Review < ActiveRecord::Base
  belongs_to :store, foreign_key: 'store_id', primary_key: 'store_id'
  
  belongs_to :food_image, foreign_key: 'vote_id', primary_key: 'vote_id'
  
  belongs_to :user, foreign_key: 'user_id', primary_key: 'user_id'
end
