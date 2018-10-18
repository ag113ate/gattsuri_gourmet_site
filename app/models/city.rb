class City < ActiveRecord::Base
  has_many :sub_cities, foreign_key: 'city_id', primary_key: 'id'
end
