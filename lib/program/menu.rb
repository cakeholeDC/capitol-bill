def start_program
    welcome
    main_menu
end

def welcome
    puts "\nWelcome to Capitol Hill"
end

def main_menu
    puts "\nDo you wish to browse by 1) Bills or 2) Members?"
    input = menu_input
    
    if input.to_i == 1
        puts "\nYou've selected Bills."
        Bill.search_by
        
    elsif input.to_i == 2
        puts "\nYou've seleted Members."
        member_options_1
        
    else
        invalid_message
        main_menu 
    end
    
end

def menu_input
    gets.strip
end


    def invalid_message
        puts "\nInvalid Input"
    end

def enter_to_continue
    puts "\nPress ENTER to continue"
    menu_input
end

# --- messages & menus regarding members ---
    def no_matching_lawmakers
        puts "No lawmakers match your criteria"
    end

# --- messages & menus regarding bills ---
    def bill_by_options
        puts "\nHow would you like to search for a bill?"
        puts "  1) Search by term or keyword"
        puts "  2) Search by bill slug"
        puts "  3) See most recent active bills"
        puts "  4) Search by sponsor"
        puts "  5) Bills by superlatives"
        puts "  6) Return to Main Menu"
    end

    def superlative_options
        puts "\nWhat bill would you like to learn about?"
        puts "  1) Bill with the most cosponsors"
        puts "  2) Bill with the most absent voters"
        puts "  3) Bill with the fewest absent voters"
        puts "  4) Bill with the longest title"
        puts "  5) Bill with the shortest title"
    end

    def request_keyword
        puts "\nPlease enter a keyword"
    end

    def request_slug
        puts "\nPlease enter a bill slug (for example, sres396 OR hr2781)"
    end

    def request_bill_limit
        puts "\nHow many bills would you like to browse? (Limit 20)"
    end

    def request_lawmaker_name
		puts "\nPlease enter a lawmaker's name"
    end

    def display_entered_value(string)
        puts "\nYou entered #{string}."
    end
    
    def request_entry_by_number(entry_type)
        puts "Please select a #{entry_type} by number"
    end
    
    def no_such_bill
        puts "\nNo such bill in our database."
    end
    
    def list_bills(bill_list)
        puts ""
        bill_list.each_with_index { |bill, index|
        puts "  #{index+1}) #{bill.slug} - #{bill.title[0..60]}..."
    }
    puts "  #{bill_list.length + 1}) Return to Main Menu"
end

def bill_menu
    puts "\n  1) Display bill details"
    puts "  2) Display vote totals"
    puts "  3) View bill text"
    puts "  4) Find the position of a specific member"
    puts "  5) Search for another bill"
    puts "Please select an option."
end

def display_bill_slug(bill)
    puts "\n  Bill Found: #{bill.slug}" 
end

def bill_detail_printout(bill)
    puts "\n#{bill.slug}: #{bill.title}"
    puts "Primary Sponsor: #{bill.sponsor}"
    puts "Number of cosponsors:"
    puts "  Total: #{bill.cosponsor_total ? bill.cosponsor_total : 0}"
    puts "  Democratic co-sponsors: #{bill.cosponsor_d ? bill.cosponsor_d : 0}"
    puts "  Republican co-sponsors: #{bill.cosponsor_r ? bill.cosponsor_r : 0}"
    puts "  Independent co-sponsors: #{bill.cosponsor_i ? bill.cosponsor_i : 0}"
    puts "Primary Topic: #{bill.primary_subject}"
    puts "Active: #{bill.active}"
end

def vote_printout(bill)
    puts "\nYea: #{bill.votes.where('vote = ?', "Yes").count}"
    puts "Nay: #{bill.votes.where('vote = ?', "No").count}"
        puts "Present: #{bill.votes.where('vote = ?', "Present").count}"
        puts "Not voting: #{bill.votes.where('vote = ?', "Not Voting").count}"
end

def no_votes
    puts "\nThis bill has not been voted upon."
end

def no_vote_in_body(body)
    puts "\nThis bill has not been voted upon in the #{body}"
end

#Below methods should be moved to Member class
    def member_ordered_list_2(results)
        results.each_with_index do |member, index|
            member_type = class_to_title(member.class)   
            puts "#{index+1}) #{member_type} #{member.full_name} - #{member.state} (#{member.party})"
        end
        
        if results.length == 0
            no_matching_lawmakers
            Bill.search_by
        else
            puts "#{results.length+1}) Return to Main Menu"
        end
    end

    def match_bills_by_sponsor(member)
        bill_list = Bill.where('sponsor_id = ?', member.api_id)
        if bill_list.length > 0
            puts "Please select a bill"
            Bill.narrow_to_one(bill_list)
        else
            puts "No bills have been sponsored by #{member.full_name}."
            Bill.search_by
        end        
    end
    
    def person_lookup_2(person)
        #gets the name
        matched_members = []
        person.split(' ').each do |name_part|
            #looks for the first name
            if HouseMember.where('first_name = ?', name_part.titlecase).length > 0
                matched_members = HouseMember.where('first_name = ? ', name_part.titlecase)
            #looks for the last name
            elsif HouseMember.where('last_name = ? ', name_part.titlecase).length > 0
                matched_members += HouseMember.where('last_name = ? ', name_part.titlecase)
            end
    
    
            if Senator.where('first_name = ? ', name_part.titlecase).length > 0
                matched_members += Senator.where('first_name = ? ', name_part.titlecase)
            elsif Senator.where('last_name = ? ', name_part.titlecase).length > 0
                matched_members += Senator.where('last_name = ? ', name_part.titlecase)
            end
    
        end
    
        if !matched_members
            no_matching_lawmakers
            Bill.search_by
        else
            #returns the array of instances
            matched_members
        end
    end