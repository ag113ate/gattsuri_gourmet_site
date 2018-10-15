class InputReview < ActiveRecord::Base
  self.primary_key = :vote_id
  
  mount_uploader :image, ImageUploader
  
  belongs_to :review, foreign_key: 'vote_id', primary_key: 'vote_id'
  
  validates :menu_name, :comment, :total_score, {presence: true}
  
  validates :menu_name, length: {maximum: 100}
  validates :comment, length: {maximum: 500}
  
  validates :total_score, \
      numericality: {greater_than_or_equal_to: 0.5, less_than_or_equal_to: 5.0}
      
end
