class AddSponsorNameToBillsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :bills, :sponsor, :string
  end
end
