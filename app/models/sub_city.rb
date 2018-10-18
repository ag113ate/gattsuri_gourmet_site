class SubCity < ActiveRecord::Base
  belongs_to :city, foreign_key: 'city_id', primary_key: 'id', dependent: :destroy
end
