# require 'image_to_ascii'

def welcome
	puts ''
	puts "Welcome to Capitol Hill"
	# ImageToAscii['./graphics/us_capitol.jpg']
	# puts ''
	main_menu
end

def main_menu
	puts ''
	puts "Do you wish to browse the database by 1) Bills or 2) Members?"
	puts ''
	bill_or_member = menu_input

	if bill_or_member.to_i == 1 || bill_or_member.downcase == "bills"  || bill_or_member.downcase == "bill"
		#prompt user to select search by criteria
		search_bill_by

	elsif bill_or_member.to_i == 2 || bill_or_member.downcase == "members" || bill_or_member.downcase == "member"
		# prompt user to select chamber
		prompt_chamber_select

	else
		puts "Invalid Input"
		main_menu 
	end

end



def menu_input
	gets.strip
end