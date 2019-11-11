class CreateSenatorsTable < ActiveRecord::Migration[6.0]
  def change
  	create_table :senators do |t|
  		t.string :first_name
  		t.string :last_name
  		t.string :state
  		t.string :party
  		t.string :state_rank
  		t.string :next_election
  		t.string :url
  		t.string :phone
  		t.float :votes_with_party_pct
  		t.float :votes_against_party_pct
  		t.float :missed_votes_pct
  		t.string :congress_id
  		t.timestamps
  	end
  end
end
