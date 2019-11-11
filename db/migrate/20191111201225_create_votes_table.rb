class CreateVotesTable < ActiveRecord::Migration[6.0]
  def change
  	create_table :votes do |t|
  		t.integer :member_id
  		t.integer :bill_id
  		t.datetime :vote_date
  		t.string :vote
  		t.timestamps
  	end
  end
end
