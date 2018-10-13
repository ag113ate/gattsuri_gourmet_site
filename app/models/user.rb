class User < ActiveRecord::Base
  has_secure_password
  
  has_many :bookmark_stores, primary_key: 'user_id', foreign_key: 'user_id', \
                                                             dependent: :destroy
  
  has_many :reviews, primary_key: 'user_id', foreign_key: 'user_id',
                                                             dependent: :destroy
  
  
  validates :user_id, {presence: true}
  validates :user_id, {uniqueness: true}
  validates :user_id, {format: {with: /\A[a-zA-Z0-9]+\Z/}}
  
  # レコードの新規作成時はhas_secure_passwordのvalidationsが実施されるが、
  # update時は行われないため
  validates :password, :password_confirmation, {presence: true, on: :update}
  
  validates :user_id, length: {maximum: 20}
  validates :password, :password_confirmation, length: {maximum: 20}
end