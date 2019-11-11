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

	when 2
		puts "State Selected"

	when 3
		puts "Party Time!"

	when 4
		member_options_1
	else
		puts "Invalid Input"
		member_options_2(body)
	end
end

def search_by_name(body)
	type = (body == "senate") ? "Senator" : "Congressman"
	puts "Please enter a #{type}'s name..."
	person = menu_input

	puts "You entered #{person}"
end

def menu_input
	gets.strip
end

binding.pry

welcome
bill_or_member



binding.pry