require_relative '../API/house_importer.rb'
require_relative '../API/senate_importer.rb'
require_relative '../API/bill_importer.rb'
require_relative '../API/votes_importer.rb'
require 'date'

# binding.pry
## TYPE exit TO RUN IMPORTER

SENATORS.each do |senator|
    Senator.create({
        api_id: senator[:id],
        full_name: "#{senator[:first_name]} #{senator[:last_name]}", ## TODO update this in the migration
        first_name: senator[:first_name],
        last_name: senator[:last_name],
        party: senator[:party],
        state: senator[:state],
        state_rank: senator[:state_rank],
        next_election: senator[:next_election],
        url: senator[:url],
        phone: senator[:phone],
        votes_with_party_pct: senator[:votes_with_party_pct],
        votes_against_party_pct: senator[:votes_against_party_pct],
        missed_votes_pct: senator[:missed_votes_pct],
    })
end

HOUSE_MEMBERS.each do |rep|
    HouseMember.create({
        api_id: rep[:congress_id],
        full_name: "#{rep[:first_name]} #{rep[:last_name]}", ## TODO update this in the migration
        first_name: rep[:first_name],
        last_name: rep[:last_name],
        party: rep[:party],
        state: rep[:state],
        district: rep[:district],
        next_election: rep[:next_election],
        url: rep[:url],
        phone: rep[:phone],
        votes_with_party_pct: rep[:votes_with_party_pct],
        votes_against_party_pct: rep[:votes_against_party_pct],
        missed_votes_pct: rep[:missed_votes_pct],
    })
end

BILLS.each do |bill|
    Bill.create({
    slug: bill[:bill_slug],
    title: bill[:title],
    primary_subject: bill[:primary_subject],
    sponsor: bill[:sponsor_name],    
    sponsor_id: bill[:sponsor_id],
    cosponsor_total: bill[:cosponsors],
    cosponsor_d: bill[:cosponsors_by_party][:D],
    cosponsor_r: bill[:cosponsors_by_party][:R],
    cosponsor_i: bill[:cosponsors_by_party][:I],
    active: bill[:active],
    introduced_date: bill[:introduced_date],
    url: bill[:congressdotgov_url]
    })
end

BILLS2.each do |bill|
    Bill.create({
    slug: bill[:results][0][:bill_slug],
    title: bill[:results][0][:title],
    primary_subject: bill[:results][0][:primary_subject],
    sponsor: bill[:results][0][:sponsor],
    sponsor_id: bill[:results][0][:sponsor_id],
    cosponsor_total: bill[:results][0][:cosponsors],
    cosponsor_d: bill[:results][0][:cosponsors_by_party][:D],
    cosponsor_r: bill[:results][0][:cosponsors_by_party][:R],
    cosponsor_i: bill[:results][0][:cosponsors_by_party][:I],
    active: bill[:results][0][:active],
    introduced_date: bill[:results][0][:introduced_date],
    url: bill[:results][0][:congressdotgov_url]
    })
end

def return_member_id(propublica_member_id, body)
    member_class = (body == "Senate") ? Senator : HouseMember
    matched_member = member_class.find_by(api_id: propublica_member_id)
    if matched_member
        matched_member.id
    else
        "NULL"
    end
end

def return_bill_id(propublica_bill_id)
    matched_bill = Bill.find_by(slug: propublica_bill_id)
    if matched_bill
        matched_bill.id
    else
        
    end
end

VOTES.each { |rollcall|
    if rollcall["results"]["votes"]["vote"]["question"].include?("Passage")
    #dive into specific bill's tally
    body = rollcall["results"]["votes"]["vote"]["chamber"]
    rollcall["results"]["votes"]["vote"]["positions"].each { |member_position|
        # binding.pry
        Vote.create({
            body: body,
            member_id:
                return_member_id(member_position["member_id"], body),     
            bill_id:
                return_bill_id(rollcall["results"]["votes"]["vote"]["bill"]["bill_id"][0...-4]),
            vote_date: Date.parse(rollcall["results"]["votes"]["vote"]["date"]),
            vote: member_position["vote_position"]
        })
    }
    end
}