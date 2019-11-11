class Senator < Member


	attr_accessor :id, :title, :short_title, :api_uri, :first_name, :middle_name, :last_name, :suffix, :date_of_birth, :gender, :party, :leadership_role, :twitter_account, :facebook_account, :youtube_account, :govtrack_id, :cspan_id, :votesmart_id, :icpsr_id, :crp_id, :google_entity_id, :fec_candidate_id, :url, :rss_url, :contact_form, :in_office, :cook_pvi, :dw_nominate, :ideal_point, :seniority, :next_election, :total_votes, :missed_votes, :total_present, :last_updated, :ocd_id, :office, :phone, :fax, :state, :senate_class, :state_rank, :lis_id, :missed_votes_pct, :votes_with_party_pct, :votes_against_party_pct

	def initialize(attributes = nil)
		attributes.each do |attribute, value|
		# binding.pry
			self.send(("#{attribute}="), value)
		end
	end

	# def initialize(options)
	# 	@options = options
	# end
end