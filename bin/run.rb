require_relative '../config/environment'



# puts "HELLO WORLD"
def welcome
	puts "Welcome to Capitol Hill"
end

def bill_or_member
	puts "Do you wish to browse by 1) Bills or 2) Members?"
	input = menu_input

	if input.to_i == 1
		puts "You've selected Bills."
		bill_options_1

	elsif input.to_i == 2
		puts "You've seleted Members."
		member_options_1

	else
		puts "Invalid Input"
		bill_or_member 
	end

end

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
	puts "1) Name"
	puts "2) State"
	puts "3) Party"
	puts "4) Return to Previous Menu"
	search = menu_input

	case search.to_i

	when 1
		puts "Name Selected"
		search_by_name(body)
	when 2
		puts "State Selected"
		search_by_state(body)
	when 3
		puts "Party Time!"

	when 4
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

def search_by_name(body)
	member_type = body_to_title(body)
	member_class = body_to_class(body)

	puts "Please enter a #{member_type}'s name..."
	person = menu_input

	puts "You entered #{person}"
	result = member_class.find_by(full_name: person.titlecase)

	if !result 
		person.split(' ').each do |name_part|
			if member_class.find_by(first_name: name_part.titlecase)
				result = member_class.find_by(first_name: name_part.titlecase)
			elsif member_class.find_by(last_name: name_part.titlecase)
				result = member_class.find_by(last_name: name_part.titlecase)
			end
		end

		if !result
			puts "ERROR: That's not a current #{member_type}!"
			search_by_name(body)
		end
	end
	member_menu(result)
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
	results.each_with_index do |member, index|
		if body == "house"
			district = " - District: #{member.district}"
		else
			district = ''
		end

		puts "#{index+1}) #{member.full_name} - #{member.party}#{district}"
	end

	puts "#{results.length+1}) Return to Main Menu"
	puts ""
	puts "Please select a #{member_type} by number"
	member_select = menu_input.to_i
	##input = results[i+1]

	## unless back to main menu
	member_menu(results[member_select-1])	

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
	puts "What data would you like about #{member.full_name}?"
	puts "1) Contact Information"
	puts "2) Sponsored Bills"
	puts "3) Next Election Year"
	puts "4) Recent Votes"
	puts "5) Vote Summary Data"
	puts "6) Visit Official Website"
	puts "7) Return to Main Menu"
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
		bill_or_member
	end
end

def menu_input
	gets.strip
end


welcome
bill_or_member



binding.pry