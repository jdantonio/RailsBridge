class AddUserIdToVotes < ActiveRecord::Migration
  def change
    change_table :votes do |t|
      t.integer :user_id
      t.index [:topic_id, :user_id]
    end
  end
end
