class HouseMember < ActiveRecord::Base
	has_many :votes
	has_many :bills, through: :votes

	# attr_accessor :first_name, :last_name, :state, :party, :district, :next_election, :url, :phone, :votes_with_party_pct, :votes_against_party_pct, :missed_votes_pct, :api_id

	# def initialize(attributes = nil)
	# 	attributes.each do |attribute, value|
	# 		self.send(("#{attribute}="), value)
	# 	end
	# end
end