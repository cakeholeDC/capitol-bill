require_relative '../config/environment'



# puts "HELLO WORLD"
def welcome
	puts "Welcome to Capitol Hill"
end

def main_menu
	puts "Do you wish to browse by 1) Bills or 2) Members?"
	input = menu_input

	if input.to_i == 1
		puts "You've selected Bills."
		search_bill_by

	elsif input.to_i == 2
		puts "You've seleted Members."
		member_options_1

	else
		puts "Invalid Input"
		main_menu 
	end

end



def menu_input
	gets.strip
end


welcome
main_menu

binding.pry