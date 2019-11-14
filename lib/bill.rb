class Bill < ActiveRecord::Base
	has_many :votes
	has_many :senators, through: :votes
	has_many :house_members, through: :votes

	def self.search_by
		bill_by_options
        search_style = menu_input
    
        case search_style.to_i
    
        when 1
            Bill.search_by_term
        when 2
            Bill.search_by_slug
        when 3
            Bill.recent_list
        when 4
            Bill.search_by_sponsor
        when 5
            main_menu
        else
            invalid_message
            Bill.search_by
        end
	end
	
	def self.narrowing_logic(results)
		#for results returned in an array
		if results.length > 1
			Bill.narrow_to_one(results)
		elsif results.length == 1
			results[0].bill_menu_choice
		else
			no_such_bill
			Bill.search_by
		end
	end

	def self.search_by_term
		request_keyword
		keyword = menu_input

		#return an array where the keyword matches
		results = (Bill.keyword_matches_title(keyword) + Bill.keyword_matches_subject(keyword)).uniq
		
		Bill.narrowing_logic(results)
	end

	def self.keyword_matches_title(keyword)
		Bill.where('title LIKE ?', "%#{keyword}%")
	end

	def self.keyword_matches_subject(keyword)
		Bill.where('primary_subject LIKE ?', "%#{keyword}%")
	end

	def self.slug_match(slug)
		Bill.find_by(slug: slug)
	end

	def self.search_by_slug
		request_slug
		slug = menu_input
		
		bill_selected = Bill.slug_match(slug)
		
		if bill_selected
			bill_selected.bill_menu_choice
		else
			no_such_bill
			Bill.search_by
		end
	end

	def self.recent_list
		request_bill_limit
		quantity = menu_input

		recent_bills = Bill.order(introduced_date: :desc).limit(quantity.to_i)

		Bill.narrowing_logic(recent_bills)
	end

	def self.search_by_sponsor
		request_lawmaker_name
		person = menu_input
	
		display_entered_value(person)
		
		# This should ideally use methods from the Member class. As such it is not yet refactored!
		member = HouseMember.find_by(full_name: person.titlecase)
		if !member
			member = Senator.find_by(full_name: person.titlecase)
		end

		if !member
			matched_members = person_lookup_2(person)
			if matched_members
				member_ordered_list_2(matched_members)
				
				request_entry_by_number("lawmaker")

				member_select = menu_input
				#End of area still to be refactored
				
				if member_select.to_i == (matched_members.length + 1)
					main_menu
				elsif member_select.to_i == 0 || member_select.to_i > matched_members.length
					invalid_message
					Bill.search_by_sponsor
				else
					member = matched_members[member_select.to_i-1]
				end			
			else
				no_matching_lawmakers
				Biil.search_by_sponsor
			end
		end
		Bill.match_by_sponsor(member)
	end

	def self.bills_by_lawmaker(lawmaker)
		Bill.where('sponsor_id = ?',  lawmaker.api_id)
	end

	def self.match_by_sponsor(sponsor)
		bill_list = Bill.bills_by_lawmaker(sponsor)

		Bill.narrowing_logic(bill_list)
	end

	def self.narrow_to_one(array_of_bills)
		list_bills(array_of_bills)
		selection = menu_input
	
		if selection.to_i == array_of_bills.length + 1
			main_menu
		elsif selection.to_i == 0 || selection.to_i > array_of_bills.length
			invalid_message
			Bill.narrow_to_one(array_of_bills)
		else
			array_of_bills[selection.to_i - 1].bill_menu_choice
		end
	end

	def bill_menu_choice
		display_bill_slug(self)
		bill_menu

		choice = menu_input

		case choice.to_i
        
		when 1
			self.display_bill_details
		when 2
			self.display_vote_totals		
		when 3
			self.open_webpage
		when 4
			self.search_member_position
		when 5
			Bill.search_by
		else
			invalid_message
			self.return_to_menu
		end
	end

	def display_bill_details
		bill_detail_printout(self)

		self.return_to_menu
	end

	def display_vote_totals
		if self.votes.count > 0
			vote_printout(self)
		else
			no_votes
		end
		self.return_to_menu
	end
	
	def return_to_menu
		enter_to_continue
		self.bill_menu_choice
	end

	def open_webpage
		Launchy.open("#{self.url}")
		self.return_to_menu
	end

	#these methods are more appropriate for the Member class
	def select_member
		request_lawmaker_name
		name = menu_input
	end

	def search_member_position
		name = self.select_member
	
		matched_members = person_lookup_2(name)
	
		if matched_members
			member_ordered_list_2(matched_members)
			request_entry_by_number("lawmaker")
			member_select = menu_input
			
			if member_select.to_i == (matched_members.length + 1)
				main_menu
			elsif member_select.to_i == 0 || member_select.to_i > matched_members.length
				invalid_message
				self.search_member_position
			else
				member = matched_members[member_select.to_i-1]
			end
		else
			no_matching_lawmakers
			Bill.search_by_sponsor
		end
		
		self.determine_position(member)
	end

	def determine_position(lawmaker)
		member_vote = self.votes.find_by('member_id = ?', lawmaker.id)

		if member_vote
			position_status(member_vote, lawmaker)
		else
			member_body = lawmaker.class == Senator ? 'Senate' : 'House'
			no_vote_in_body(member_body)
		end

		self.return_to_menu
	end

end