class InputReview < ActiveRecord::Base
  self.primary_key = :vote_id
  
  mount_uploader :image, ImageUploader
  
  belongs_to :store, foreign_key: 'store_id', primary_key: 'store_id'
  belongs_to :user, foreign_key: 'user_id', primary_key: 'user_id'
  
  validates :menu_name, :comment, :total_score, {presence: true}
  
  validates :menu_name, length: {maximum: 100}
  validates :comment, length: {maximum: 500}
  
  validates :total_score, \
      numericality: {greater_than_or_equal_to: 0.5, less_than_or_equal_to: 5.0}
      
end
