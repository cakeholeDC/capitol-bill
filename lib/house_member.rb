class HouseMember < ActiveRecord::Base
	has_many :votes
	has_many :bills, through: :votes

	# attr_accessor :first_name, :last_name, :state, :party, :district, :next_election, :url, :phone, :votes_with_party_pct, :votes_against_party_pct, :missed_votes_pct, :api_id

		#superlative methods
		def self.most_missed_votes
			HouseMember.all.reduce { |memo, member|
					memo.missed_votes_pct.to_f > member.missed_votes_pct.to_f ? memo : member
			} 
		end
	
	
		def self.most_partisan
			#remember to exclude independents
			HouseMember.all.reduce { |memo, member|
					memo.votes_with_party_pct.to_f > member.votes_with_party_pct.to_f || member.party == 'I' ? memo : member
			}
		end
	
		def self.most_bipartisan
			HouseMember.all.reduce { |memo, member|
				memo.votes_against_party_pct.to_f > member.votes_against_party_pct.to_f || member.party == 'I' ? memo : member
			}
		end
end