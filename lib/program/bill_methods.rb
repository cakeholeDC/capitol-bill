
def bill_by_options
    puts "  1) Search by term or keyword"
    puts "  2) Search by bill slug"
    puts "  3) See most recent active bills"
    puts "  4) Search by sponsor"
    puts "  5) Return to Previous Menu"
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
    puts "Functionality not currently supported"
    search_bill_by
end

def bill_menu
    puts ""
    puts "  1) Display bill details"
    puts "  2) Display vote totals"
    puts "  3) View bill text"
    puts "  4) Search for another bill \n "
    puts "Please select an option."
end

def bill_menu_choice(bill)
    "Bill Found: #{bill.slug}"
    bill_menu
    choice = menu_input
    
    case choice.to_i
        
    when 1
        display_bill_details(bill)
        
    when 2
        display_vote_menu
        
    when 3
        Launchy.open("#{bill.url}")
        main_menu
    when 4
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
    puts "Functionality is not yet supported"
end
