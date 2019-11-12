class AddIntroducedDateToBills < ActiveRecord::Migration[6.0]
  def change
    add_column :bills, :introduced_date, :string
  end
end
