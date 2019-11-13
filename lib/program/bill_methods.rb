
def bill_by_options
    puts "  1) Search by term or keyword"
    puts "  2) Search by bill slug"
    puts "  3) See most recent active bills"
    puts "  4) Search by sponsor"
    puts "  5) Return to Main Menu"
end

def search_bill_by
    puts ""
    puts "How would you like to search for a bill?"
    bill_by_options
    search_style = menu_input

    case search_style.to_i

    when 1
        search_by_term()
    
    when 2
        search_by_slug()
    
    when 3
        puts "List of Recent Active Bills"
        recent_list()
    
    when 4
        puts "Search by sponsor"
        search_by_sponsor()
    
    when 5
        main_menu
    
    else
        puts "Invalid Input"
        search_bill_by
    end
end

def search_by_term
    puts "Please enter a keyword"
    keyword = menu_input
    bills_matched_by_title = Bill.where('title LIKE ?', "%#{keyword}%")
    bills_matched_by_subject = Bill.where('primary_subject LIKE ?', "%#{keyword}%")
    results = bills_matched_by_title + bills_matched_by_subject
    
    #when results exist
    if results.length > 1
        narrow_to_one_bill(results.uniq)
    elsif results.length == 1
        bill_menu_choice(results[0])
    else
        #break for no results
        puts ""
        puts "No such bill in our database"
        search_bill_by
    end

end

def narrow_to_one_bill(bill_array)
    list_bills(bill_array)
    selection = menu_input

    if selection.to_i == bill_array.length + 1
        main_menu
    else
      index = selection.to_i - 1
      bill_menu_choice(bill_array[index])
    end
end

def list_bills(bill_list)
    puts ""
    bill_list.each_with_index { |bill, index|
        puts "  #{index+1}) #{bill.slug} - #{bill.title[0..40]}..."
    }
    puts "  #{bill_list.length + 1}) Return to Main Menu"
    puts ""
end


def search_by_slug
    puts ""
    puts "Please enter a bill slug (for example, sres396 OR hr2781"
    slug = menu_input
    
    bill_selected = Bill.find_by(slug: slug)
    if bill_selected
        bill_menu_choice(bill_selected)
    else
        puts ""
        puts "No such bill in our database"
        search_bill_by
    end
end

def recent_list
    puts ""
    puts "How many bills would you like to browse? (Limit 20)"
    # binding.pry
    quantity = menu_input
    recent_bills = Bill.order(introduced_date: :desc).limit(quantity.to_i)

    if recent_bills.length > 1
        narrow_to_one_bill(recent_bills)
    elsif recent_bills.length == 1
        bill_menu_choice(recent_bills[0])
    else
        puts ""
        puts "No such bill in our database"
        search_bill_by
    end
end

def search_by_sponsor
    puts ""
    puts "Please enter a member's name"
    person = menu_input

	puts "You entered #{person}"
    member = HouseMember.find_by(full_name: person.titlecase)
    if !member
        member = Senator.find_by(full_name: person.titlecase)
    end
\
	if !member
		matched_members = person_lookup_2(person)
		if matched_members
			member_ordered_list_2(matched_members)
			puts "Please select a lawmaker by number"
			member_select = menu_input
            
            if member_select.to_i == (matched_members.length + 1)
                main_menu
            elsif member_select.to_i == 0 || member_select.to_i > matched_members.length
                puts ""
                puts "Invalid Input"
                search_by_sponsor
            else
                member = matched_members[member_select.to_i-1]
			end			
		else
			puts "No lawmakers match your criteria"
			search_by_sponsor()
		end
    end
    match_bills_by_sponsor(member)
end

def match_bills_by_sponsor(member)
    bill_list = Bill.where('sponsor_id = ?', member.api_id)
    if bill_list.length > 0
        puts "Please select a bill"
        narrow_to_one_bill(bill_list)
    else
        puts "No bills have been sponsored by #{member.full_name}."
        search_bill_by()
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
        puts "No lawmakers matched your inquiry!"
        search_bill_by
	else
		#returns the array of instances
		matched_members
	end
end

def member_ordered_list_2(results)
    results.each_with_index do |member, index|
        member_type = class_to_title(member.class)   
		puts "#{index+1}) #{member_type} #{member.full_name} - #{member.party} #{member.state}"
	end
    
    if results.length == 0
		puts "No lawmakers match your criteria."
		puts ""
		search_bill_by
	else
		puts "#{results.length+1}) Return to Main Menu"
		puts ""
	end
end

def bill_menu
    puts ""
    puts "  1) Display bill details"
    puts "  2) Display vote totals"
    puts "  3) View bill text"
    puts "  4) Find the position of a specific member"
    puts "  5) Search for another bill \n "
    puts "Please select an option."
end

def bill_menu_choice(bill)
    puts ""
    puts "Bill Found: #{bill.slug}"
    bill_menu
    choice = menu_input
    
    case choice.to_i
        
    when 1
        display_bill_details(bill)
        
    when 2
        display_vote_totals(bill)
        
    when 3
        Launchy.open("#{bill.url}")
        main_menu
    when 4
        search_member_position(bill)
    when 5
        search_bill_by
    else
        puts "INVALID INPUT"
        bill_menu_choice(bill)
    end
end

def display_bill_details(bill)
    puts ""
    puts "#{bill.slug}: #{bill.title}"
    puts "Primary Sponsor: #{bill.sponsor}"
    puts "Number of cosponsors:"
    puts "  Total: #{bill.cosponsor_total ? bill.cosponsor_total : 0}"
    puts "  Democratic co-sponsors: #{bill.cosponsor_d ? bill.cosponsor_d : 0}"
    puts "  Republican co-sponsors: #{bill.cosponsor_r ? bill.cosponsor_r : 0}"
    puts "  Independent co-sponsors: #{bill.cosponsor_i ? bill.cosponsor_i : 0}"
    puts "Primary Topic: #{bill.primary_subject}"
    puts "Active: #{bill.active}"
    puts ""
    puts "Press ENTER to continue"
    input = menu_input
    if input
        bill_menu_choice(bill)
    end
end

def display_vote_totals(bill)
    puts ""
    if bill.votes.count > 0
        puts "Yea: #{bill.votes.where('vote = ?', "Yes").count}"
        puts "Nay: #{bill.votes.where('vote = ?', "No").count}"
        puts "Present: #{bill.votes.where('vote = ?', "Present").count}"
        puts "Not voting: #{bill.votes.where('vote = ?', "Not Voting").count}"
    else
        puts "This bill has not been voted upon."
    end
    puts ""
    puts "Press ENTER to continue"
    input = menu_input
    if input
        bill_menu_choice(bill)
    end
end

def search_member_position(bill)
    puts ""
    puts "Please enter a member's name"
    name = menu_input

    matched_members = person_lookup_2(name)
     
    if matched_members
        member_ordered_list_2(matched_members)
        puts "Please select a lawmaker by number"
        member_select = menu_input
        
        if member_select.to_i == (matched_members.length + 1)
            main_menu
        elsif member_select.to_i == 0 || member_select.to_i > matched_members.length
            puts ""
            puts "Invalid Input"
            search_member_position(bill)
        else
            member = matched_members[member_select.to_i-1]
        end			
    else
        puts "No lawmakers match your criteria"
        search_by_sponsor()
    end

    member_vote = bill.votes.find_by('member_id = ?', member.id)
    
    if member_vote
        puts "#{member.full_name} position was #{member_vote.vote} on #{bill.slug}."
    else
        member_body = member.class == Senator ? 'Senate' : 'House'
        puts "This bill has not been voted on yet in the #{member_body}"
    end
    puts ""
    puts "Press ENTER to continue"
    input = menu_input
    if input
        bill_menu_choice(bill)
    end
end