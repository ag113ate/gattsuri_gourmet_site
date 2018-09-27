class BookmarkStore < ActiveRecord::Base
    belongs_to :user, primary_key: 'user_id', foreign_key: 'user_id'
    belongs_to :store, primary_key: 'store_id', foreign_key: 'store_id'
end
