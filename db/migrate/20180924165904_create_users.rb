class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, {id:false, primary_key: :user_id} do |t|
      t.string :user_id
      t.string :password_digest

      t.timestamps
    end
  end
end
