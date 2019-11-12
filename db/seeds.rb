require_relative '../API/house_importer.rb'
require_relative '../API/senate_importer.rb'
require_relative '../API/bill_importer.rb'

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
        api_id: rep[:id],
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
    sponsor_id: bill[:sponsor_id],
    cosponsor_total: bill[:cosponsors],
    cosponsor_d: bill[:cosponsors_by_party][:D],
    cosponsor_r: bill[:cosponsors_by_party][:R],
    cosponsor_i: bill[:cosponsors_by_party][:I],
    active: bill[:active],
    url: bill[:congressdotgov_url]
    })
end