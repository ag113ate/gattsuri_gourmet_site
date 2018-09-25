class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id:false do |t|
      t.column :user_id, 'STRING PRIMARY KEY'
      t.string :password_digest

      t.timestamps
    end
  end
end
