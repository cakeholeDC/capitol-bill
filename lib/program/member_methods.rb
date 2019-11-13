def chamber_select_menu
	puts ""
	puts "Which chamber of Congress would you like to browse?"
	puts ''
	puts "	1) House of Representatives" 
	puts "	2) Senate"
	puts ""

	chamber = menu_input

	if chamber.downcase == "house" || chamber.to_i == 1 || chamber.downcase.include?("house")
		member_search_options("house")
	elsif chamber.downcase == "senate" || chamber.to_i == 2
		member_search_options("senate")
	else 
		puts ''
		puts "That's not a chamber of Congress; please try again."
		chamber_select_menu
	end		

end

def member_type(body)
	(body == "senate") ? "Senator" : "Congressman"
end

def member_class(body)
	(body == "senate") ? Senator : HouseMember
end

def member_search_options(body)
	puts ''
	puts "How would you like to search for a #{member_type(body)}?"
	puts ''
	puts "	1) Search by Name"
	puts "	2) Search by State"
	puts "	3) Back Previous Menu"
	puts "	4) Main Menu"
	puts ''
	member_by_options(body)
end

def member_by_options(body)
	search = menu_input

	# case search#.to_i
	if search.to_i == 1 || search.downcase == "name"
		search_by_name(body)
	elsif search.to_i == 2 || search.downcase == "state"
		search_by_state(body)
	elsif search.to_i == 3 || search.downcase == "back"
		chamber_select_menu
	elsif search.to_i == 4 || search.downcase == "main menu"
		main_menu
	else
		puts "Invalid Input"
		member_by_options(body)
	end
end



def narrow_member_search_results(matched_results, person, chamber)
	##INSIDE NARROW MEMBER RESULTS
	binding.pry
	puts ''
	puts "Here's all #{member_type(chamber).pluralize} matching '#{person}':"
	puts ''

	member_ordered_list(matched_results, chamber)

	## @HELPER filter_by_party
	puts "Please select a #{member_type(chamber)} by number"
	puts "or type 'R', 'D', or 'I' to select a party"
	puts ''

	member_or_party = menu_input

	# if R, D or I was entered, this value will be 0
	if member_or_party.to_i == 0

		# get a list of filtered results
		filtered_results = filter_by_party(matched_results, member_or_party, chamber)
		
		# display the list
		select_member_by_number(member_type(chamber), filtered_results)

	# if a member number was entered, bring up that members options
	else
		member_menu(matched_results[member_or_party.to_i-1])		
	end	
end

def search_by_name(chamber)
	member_class = member_class(chamber)

	puts ''
	puts "Please enter a #{member_type(chamber)}'s name:"
	puts ''
	person = menu_input

	if person.to_i != 0
		if person.to_i == 4
			main_menu 
		else
			puts "That's not a name."
			member_search_options(chamber)
		end
	end

	#represents an exaxt match by full name
	member = member_class.find_by(full_name: person.titlecase)

	if !member 
		# if no exact full name match, continue searching

		# call method to search by first_name and last_name individually
		search_results = person_lookup(person, member_type(chamber), member_class)
		if search_results

			if search_results.length > 1
				narrow_member_search_results(search_results, person, chamber)
			else
				member_menu(search_results[0])
			end
			
			# puts ''
			# puts "Here's all #{member_type(chamber).pluralize} matching '#{person}':"
			# puts ''

			# member_ordered_list(matched_members, chamber)

			# puts "Please select a #{member_type(chamber)} by number"
			# puts "or type 'R', 'D', or 'I' to select a party"
			# puts ''
			# member_select = menu_input
			# ##HELPER TO CONVERT STRING/INTEGERS AS NECESSARY

			# if member_select.to_i == 0
			# 	filtered_results = filter_by_party(matched_members, member_select, chamber)
			# 	select_member_by_number(member_type(chamber), filtered_results)
			# else
			# 	member_menu(matched_members[member_select.to_i-1])		
			# end			
		else
			#ERROR COMES FROM PERSON LOOKUP
			search_by_name(chamber)
		end
	end
	member_menu(member)
end

def person_lookup(person, member_type, member_class)
	
	matched_members = []

	#gets passed user input as 'person'
	person.split(' ').each do |name_part|
		
		## @BUG - this will only search first_name OR last_name, not both
		# Example = ['Stewart', 'Cole', 'James', 'Martin'] could be a First Name or a Last Name
		
		#looks for first name matches
		if member_class.where('first_name = ?', name_part.titlecase).length > 0
			matched_members = member_class.where('first_name = ? ', name_part.titlecase)
		# looks for last name matches
		elsif member_class.where('last_name = ? ', name_part.titlecase).length > 0
			matched_members = member_class.where('last_name = ? ', name_part.titlecase)
		end
	end

	if !matched_members
		puts "No current #{member_type} found matching #{person}."
	else
		#returns the array of instances
		matched_members
	end
	
end

def member_ordered_list(results, body)
	member_type = member_type(body)
	puts ''
	results.each_with_index do |member, index|
		if body == "house"
			if member.district.length == 1
				district = " #{member.state}-0#{member.district}"
			else
				district = " #{member.state}-#{member.district}"
			end
		else
			district = ''
		end

		puts "#{index+1}) #{member.full_name} (#{member.party})#{district}"
	end
	if results.length == 0
		puts "There are no such #{member_type.pluralize} that match."
		puts ""
		member_by_options(body)
	else
		puts "#{results.length+1}) Return to Main Menu"
		puts ""
	end
end

def search_by_state(body)
	member_type = member_type(body)
	member_class = member_class(body)
	
	puts "Which state would you like to find #{member_type.pluralize} for?"
	state = menu_input
	
	if state.length > 2
		state = ModelUN.convert_state_name(state)
	else
		state = state.upcase
	end

	## IF DC DO EASTER EGG & BACK TO MENU

	results = member_class.where('state = ?', state) ##is array
	if body == "house" && results.length > 1
		# results.each do |member|
		# 	binding.pry
		# 	member[:district] = member[:district].to_i
		# end
		# binding.pry
		results = results.order(:district)
	end

	puts ''
	member_ordered_list(results, body)
	

	puts "Please select a #{member_type} by number"
	puts "or type 'R', 'D', or 'I' to select a party"
	member_select = menu_input
	
	if member_select.to_i == 0
		filtered_results = filter_by_party(results, member_select, body)
		select_member_by_number(member_type, filtered_results)
	else
		member_menu(results[member_select.to_i-1])		
	end
	
end

def select_member_by_number(member_type, filtered_results)
	puts "Please select a #{member_type} by number"
		##HELPER
	member_select = menu_input.to_i
		if member_select == filtered_results.length + 1
			main_menu
		else
			member_menu(filtered_results[member_select-1])		
		end
end

def filter_by_party(results, input, body)

	puts "Please select a #{member_type(body)} by number"
	puts "or type 'R', 'D', or 'I' to select a party"

	if input.to_i == results.length+1
		#return to main menu
		main_menu
	elsif input.upcase == 'R' || input.upcase == 'D' || input.upcase == 'I'
		filtered_results = results.where('party = ?', input.upcase)
		member_ordered_list(filtered_results, body)
		   ## todo party name logic
		   if filtered_results.length == 0
			puts "No #{member_type.pluralize} meet your requirements."
			member_by_options(body)
		   end
		filtered_results
	# else
		# puts "invalid input"
		# filter_by_party(results, input, body)
	end
end 

def return_to_member_menu(member)
	puts ''
	puts "Hit ENTER to return to Member Options"
	input = menu_input
	if input
		member_menu(member)
	end
end

def member_menu(member)
	puts ''
	puts "What would you like to learn about #{member.full_name}?"
	puts "	1) Contact Information"
	puts "	2) Sponsored Bills"
	puts "	3) Next Election Year"
	puts "	4) Recent Votes"
	puts "	5) Vote Summary Data"
	puts "	6) Visit Official Website"
	puts "	7) Return to Main Menu"
	puts ""

	input = menu_input

	case input.to_i
	when 1 ## CONTACT INFO
		puts ''
		puts "Telephone: #{member.phone}"
		puts "Website: #{member.url}"
		return_to_member_menu(member)
	when 2 ## SPONSORED BILLS
		puts ''
		puts "this feature is not fully implemented yet, please check back soon"
		# puts "#{member.full_name}'s Sponsored Bills:"
		## TO DO
		return_to_member_menu(member)
		puts ''
	when 3 ## TERM END
		puts "#{member.full_name}'s term ends in #{member.next_election}"
		return_to_member_menu(member)
	when 4 ## RECENT VOTES
		puts ''
		puts "this feature is not fully implemented yet, please check back soon"
		## TO DO, RECENT VOTES
		return_to_member_menu(member)
	when 5 ## VOTING RECORD
		puts ''
		puts "#{member.full_name}'s voting record:"
		puts "   Votes with own party (#{member.party}): #{member.votes_with_party_pct}\% of the time"
		puts "   Votes against own party (#{member.party}): #{member.votes_against_party_pct}\% of the time"
		puts "   Has missed #{member.missed_votes_pct}\% of votes this session"
		return_to_member_menu(member)
	when 6 ## WEBSITE
		Launchy.open("#{member.url}")
		member_menu(member)
	when 7 ## MAIN MENU
		main_menu
	end
end