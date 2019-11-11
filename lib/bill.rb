class Bill < ActiveRecord::Base
	has_many :votes
	has_many :senators, through: :votes
	has_many :house_members, through: :votes
end