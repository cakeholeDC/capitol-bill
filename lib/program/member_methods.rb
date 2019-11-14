def member_type(body)
	(body == "senate") ? "Senator" : "Congressman"
end

def member_class(body)
	(body == "senate") ? Senator : HouseMember
end

def prompt_chamber_options(chamber)
	chamber_menu(chamber)
	get_chamber_option(chamber)
end

def get_chamber_option(chamber)
	search = menu_input

	# case search#.to_i
	if search.to_i == 1 || search.downcase == "name"
		get_member_by_name(chamber)
	elsif search.to_i == 2 || search.downcase == "state"
		search_by_state(chamber)
	elsif search.to_i == 3 || search.downcase == "back"
		prompt_chamber_select
	elsif search.to_i == 4 || search.downcase == "main menu"
		main_menu
	else
		invalid_message
		get_chamber_option(chamber)
	end
end

def prompt_members_with_index(results, search_criteria, chamber, party='')
	
	unless results.length == 0
		puts ''
		puts "Here's all #{party}#{member_type(chamber).pluralize} matching '#{search_criteria}':"
		puts ''
	end

	results.each_with_index do |member, index|
		
		if chamber == "house"
			if member.district.length == 1
				district = " #{member.state}-0#{member.district}"
			else
				district = " #{member.state}-#{member.district}"
			end
		else
			district = ''
		end

		# display an ordered list
		puts "	#{index+1}) #{member.full_name} (#{member.party})#{district}"
	end

	if results.length == 0
		puts ''
		puts "There are no #{member_type(chamber).pluralize} that match '#{search_criteria}'."
		puts ""
		prompt_chamber_options(chamber)
	else
		#output one final option to return to main menu
		puts "#{results.length+1}) Return to Main Menu"
		puts ''
	end
end


def get_member_by_name(chamber)
	member_class = member_class(chamber)

	prompt_member_by_name(chamber)

	member_query = menu_input

	if member_query.to_i != 0
		if member_query.to_i == 4
			main_menu 
		else
			puts "That's not a name."
			prompt_chamber_options(chamber)
		end
	end

	#represents an exact match by full name
	member_match = member_class.find_by(full_name: member_query.titlecase)
	# if no exact full name match, continue searching
	if !member_match 

		# call method to search by first_name and last_name individually
		found_members = scan_data_for_both_names(member_query, member_type(chamber), member_class)

		if found_members

			if found_members.length == 0
				prompt_members_with_index(found_members, member_query, chamber)

			elsif found_members.length > 1
				# give the user an option to sort by party
				narrow_member_search_results(found_members, member_query, chamber)

			else
				member_menu(found_members[0])
			end
				
		else
			binding.pry
			# ERROR COMES FROM scan_data_for_both_names method
			# @TODO should probably be here
			get_member_by_name(chamber)
		end
	end
	member_menu(member_match)
end

def class_to_title(body_as_class)
	(body_as_class == Senator) ? "Senator" : "Congressman"
end

def scan_data_for_both_names(person, member_type, member_class)
	
	matched_members = []

	#gets passed user input as 'person'
	person.split(' ').each do |name_part|
			matched_members += member_class.where('first_name = ? ', name_part.titlecase)
			matched_members += member_class.where('last_name = ? ', name_part.titlecase)
	end

	if !matched_members
		puts "No current #{member_type} found matching #{person}."
	else
		#returns the array of instances
		matched_members
	end
	
end

def narrow_member_search_results(matched_results, person, chamber)

	# display a list of results with index+1
	prompt_members_with_index(matched_results, person, chamber)
	filter_by_party(matched_results, chamber)
end

def filter_by_party(results, chamber, input='')

	puts "Please select a #{member_type(chamber)} by number"
	puts "or type 'R', 'D', or 'I' to filter by party"
	puts ''

	member_or_party = menu_input

	# if user selects the last item on the list
	if member_or_party.to_i == results.length+1
		#return to main menu
		main_menu

	elsif member_or_party.upcase == 'R' || member_or_party.upcase == 'D' || member_or_party.upcase == 'I'

		filtered_results = results.where('party = ?', member_or_party.upcase)

		if filtered_results.length == 0
			puts''
			puts "No #{member_type(chamber).pluralize} meet your requirements."
			prompt_chamber_options(chamber)
	   	end

	   	party = member_or_party.upcase == "D" ? "Democratic " 
	   				: member_or_party.upcase == "R" ? "Reublican " 
	   				: member_or_party.upcase == "I" ? "Independent " : ''

		##prompt user with a fildered list by party.
		prompt_members_with_index(filtered_results, input, chamber, party)

		#get user input again
		select_member_by_number(chamber, filtered_results)

	elsif member_or_party.to_i == 0 || member_or_party.to_i > results.length + 1
		invalid_message
		puts ''
		filter_by_party(results, chamber, input)
	else
		member_menu(results[member_or_party.to_i-1])
	end
end 

def select_member_by_number(chamber, member_list)
	puts "\nPlease select a #{member_type(chamber)} by number:"
	
	member_select = menu_input.to_i
		if member_select > member_list.length + 1
			invalid_message
			puts ''
			select_member_by_number(chamber, member_list)
		elsif member_select == member_list.length + 1
			main_menu
		else
			member_menu(member_list[member_select-1])		
		end
end

def search_by_state(chamber)
	state_prompt(chamber)

	state = menu_input
	
	if state.length > 2
		state = ModelUN.convert_state_name(state)
	else
		state = state.upcase
	end

	## IF DC DO EASTER EGG & BACK TO MENU

	results = member_class(chamber).where('state = ?', state) ##is array
	if chamber == "house" && results.length > 1
		results = results.order(:district)
	end

	prompt_members_with_index(results, state, chamber)
	
	filter_by_party(results, chamber, state)	
end



def enter_to_return_to_member_menu(member)
	puts "\nHit ENTER to return to Member Options"
	menu_input
	member_menu(member)
end

def member_menu(member)
	prompt_member_menu(member)

	member_selection = menu_input

	case member_selection.to_i

	when 1 ## CONTACT INFO
		puts ''
		puts "Telephone: #{member.phone}"
		puts "Website: #{member.url}"
		enter_to_return_to_member_menu(member)

	when 2 ## SPONSORED BILLS
		puts "#{member.full_name}'s Sponsored Bills:"
		sponsored = Bill.bills_by_lawmaker(member)
		if sponsored.length > 0
			puts "Please select a bill:"
			Bill.narrow_to_one(sponsored)
		else
			no_such_bill
		end
		enter_to_return_to_member_menu(member)

	when 3 ## TERM END
		puts "#{member.full_name}'s term ends in #{member.next_election}"
		enter_to_return_to_member_menu(member)
	
	when 4 ## RECENT VOTES
		puts "\n#{member.full_name}'s voting record:"
		puts ''
		display_votes(member)
	
		enter_to_return_to_member_menu(member)

	when 5 ## VOTING RECORD
		display_voting_record(member)
		enter_to_return_to_member_menu(member)
	
	when 6 ## WEBSITE
		Launchy.open("#{member.url}")
		member_menu(member)
	
	when 7 ## MAIN MENU
		main_menu
	end
end