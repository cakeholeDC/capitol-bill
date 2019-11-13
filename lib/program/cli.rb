def welcome
	puts "Welcome to Capitol Hill"
	puts ''
	main_menu
end

def main_menu
	puts "Do you wish to browse the database by 1) Bills or 2) Members?"
	puts ''
	bill_or_member = menu_input

	if bill_or_member.to_i == 1 || bill_or_member.downcase == "bills"  || bill_or_member.downcase == "bill"
		#prompt user to select search by criteria
		search_bill_by

	elsif bill_or_member.to_i == 2 || bill_or_member.downcase == "members" || bill_or_member.downcase == "member"
		# prompt user to select chamber
		chamber_select_menu

	else
		puts "Invalid Input"
		main_menu 
	end

end



def menu_input
	gets.strip
end