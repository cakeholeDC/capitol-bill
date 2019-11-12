
def member_options_1
	puts "Are you looking for a member in the House or Senate?"
	body = menu_input.downcase

	if body == "house"
		puts "House Selected"
		member_options_2(body)

	elsif body == "senate"
		puts "Senate Selected"
		member_options_2(body)

	else 
		puts "Invalid Input"
		member_options_1
	end

		
end

def member_options_2(body)
	#body is lowercase 'house' or 'senate'
	puts "What would you like to search by?"
	puts "   1) Name"
	puts "   2) State"
	# puts "   3) Party"
	puts "   3) Return to Previous Menu"
	search = menu_input

	case search.to_i

	when 1
		puts "Name Selected"
		search_by_name(body)
	when 2
		puts "State Selected"
		search_by_state(body)
	# when 3
	# 	puts "Party Time!"

	when 3
		member_options_1
	else
		puts "Invalid Input"
		member_options_2(body)
	end
end

def body_to_title(body)
	(body == "senate") ? "Senator" : "Congressman"
end

def body_to_class(body)
	(body == "senate") ? Senator : HouseMember
end

def person_lookup(person, member_type, member_class)
	#gets the name
	matched_members = []
	person.split(' ').each do |name_part|
		#looks for the first name
		if member_class.where('first_name = ?', name_part.titlecase).length > 0
			matched_members = member_class.where('first_name = ? ', name_part.titlecase)
		#looks for the last name
		elsif member_class.where('last_name = ? ', name_part.titlecase).length > 0
			matched_members = member_class.where('last_name = ? ', name_part.titlecase)
			# binding.pry
		end
	end
	# binding.pry

	if !matched_members
		puts "ERROR: That's not a current #{member_type}!"
	else
		#returns the array of instances
		matched_members
	end
	
end

def search_by_name(body)
	member_type = body_to_title(body)
	member_class = body_to_class(body)

	puts "Please enter a #{member_type}'s name..."
	person = menu_input

	puts "You entered #{person}"
	member = member_class.find_by(full_name: person.titlecase)
	# member = member_class.where('')
	# binding.pry

	if !member 
		matched_members = person_lookup(person, member_type, member_class)
		if matched_members
			member_ordered_list(matched_members, body)
			puts "Please select a #{member_type} by number or type 'R', 'D', or 'I' to select a party"
			member_select = menu_input
			##HELPER TO CONVERT STRING/INTEGERS AS NECESSARY

			if member_select.to_i == 0
				filtered_results = filter_by_party(matched_members, member_select, body)
				select_member_by_number(member_type, filtered_results)
			else
				member_menu(matched_members[member_select.to_i-1])		
			end			
		else
			#ERROR COMES FROM PERSON LOOKUP
			search_by_name(body)
		end
	end
	member_menu(member)
end

def member_ordered_list(results, body)
	member_type = body_to_title(body)
	results.each_with_index do |member, index|
		if body == "house"
			district = " - District: #{member.district}"
		else
			district = ''
		end

		puts "#{index+1}) #{member.full_name} - #{member.party}#{district}"
	end
	if results.length == 0
		puts "There are no such #{member_type.pluralize} that match."
		puts ""
		member_options_2(body)
	else
		puts "#{results.length+1}) Return to Main Menu"
		puts ""
	end
end

def search_by_state(body)
	member_type = body_to_title(body)
	member_class = body_to_class(body)
	
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
	

	puts "Please select a #{member_type} by number or type 'R', 'D', or 'I' to select a party"
	member_select = menu_input
	# binding.pry
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
	if input.to_i == results.length+1
		#return to main menu
		   main_menu
	elsif input.upcase == 'R' || input.upcase == 'D' || input.upcase == 'I'
		filtered_results = results.where('party = ?', input.upcase)
		member_ordered_list(filtered_results, body)
		   ## todo party name logic
		   if filtered_results.length == 0
			puts "No #{member_type.pluralize} meet your requirements."
			member_options_2(body)
		   end
		filtered_results
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
	puts "What would you like to learn about #{member.full_name}?"
	puts "   1) Contact Information"
	puts "   2) Sponsored Bills"
	puts "   3) Next Election Year"
	puts "   4) Recent Votes"
	puts "   5) Vote Summary Data"
	puts "   6) Visit Official Website"
	puts "   7) Return to Main Menu"
	puts ""

	input = menu_input

	case input.to_i
	when 1
		puts "Telephone: #{member.phone}"
		puts "Website: #{member.url}"
		return_to_member_menu(member)
	when 2
		puts "#{member.full_name}'s Sponsored Bills:"
		## TO DO
		return_to_member_menu(member)
	when 3
		puts "#{member.full_name}'s term ends in #{member.next_election}"
		return_to_member_menu(member)
	when 4
		## TO DO, RECENT VOTES
		return_to_member_menu(member)
	when 5
		puts "#{member.full_name}'s voting record:"
		puts "   Votes with own party (#{member.party}): #{member.votes_with_party_pct}\% of the time"
		puts "   Votes against own party (#{member.party}): #{member.votes_against_party_pct}\% of the time"
		puts "   Has missed #{member.missed_votes_pct}\% of votes this session"
		return_to_member_menu(member)
	when 6
		Launchy.open("#{member.url}")
		member_menu(member)
	when 7 # MAIN MENU
		main_menu
	end
end