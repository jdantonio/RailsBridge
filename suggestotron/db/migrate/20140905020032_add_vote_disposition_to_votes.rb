class AddVoteDispositionToVotes < ActiveRecord::Migration
  def change
    change_table :votes do |t|
      t.integer :disposition, nil: false, default: 1 # up
    end
  end
end
