class User < ActiveRecord::Base
  has_secure_password
  
  has_many :bookmark_stores, primary_key: 'user_id', foreign_key: 'user_id'
end
