class Vote < ActiveRecord::Base
	belongs_to :house_member
	belongs_to :senator
	belongs_to :bill
end