class AddBodyColumnToVotes < ActiveRecord::Migration[6.0]
  def change
    add_column :votes, :body, :string
  end
end
