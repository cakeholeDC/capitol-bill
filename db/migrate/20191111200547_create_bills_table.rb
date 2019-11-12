class CreateBillsTable < ActiveRecord::Migration[6.0]
  def change
  	create_table :bills do |t|
  		t.string :slug
  		t.string :title
  		t.string :primary_subject
  		t.string :sponsor_id 
  		t.integer :cosponsor_total
  		t.integer :cosponsor_d
  		t.integer :cosponsor_r
  		t.integer :cosponsor_i
  		t.boolean :active
  		t.string :url
  		t.timestamps
  	end
  end
end
