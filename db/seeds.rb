require_relative '../API/house_importer.rb'
require_relative '../API/senate_importer.rb'

binding.pry
## TYPE exit TO RUN IMPORTER

SENATORS.each do |senator|
    Senator.create({
        # congress_id: senator[:id], ## TODO update this in the migration
        api_id: senator[:id],
        # full_name: "#{senator[:first_name]} #{senator[:middle_name]} #{senator[:last_name]}", ## TODO update this in the migration
        first_name: senator[:first_name],
        # middle_name: senator[:middle_name],
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
        # congress_id: rep[:id], ## TODO update this in the migration
        api_id: rep[:id],
        # full_name: "#{rep[:first_name]} #{rep[:middle_name]} #{rep[:last_name]}", ## TODO update this in the migration
        first_name: rep[:first_name],
        # middle_name: rep[:middle_name],
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

# RAW API DATA
# chuck = Senator.create({
#                  "id": "S000148",
#                  "title": "Senator, 3rd Class",
#                  "short_title": "Sen.",
#                  "api_uri":"https://api.propublica.org/congress/v1/members/S000148.json",
#                  "first_name": "Charles",
#                  "middle_name": "E.",
#                  "last_name": "Schumer",
#                  "suffix": "NULL",
#                  "date_of_birth": "1950-11-23",
#                  "gender": "M",
#                  "party": "D",
#                  "leadership_role": "Senate Minority Leader",
#                  "twitter_account": "SenSchumer",
#                  "facebook_account": "senschumer",
#                  "youtube_account": "SenatorSchumer",
#                  "govtrack_id": "300087",
#                  "cspan_id": "5929",
#                  "votesmart_id": "26976",
#                  "icpsr_id": "14858",
#                  "crp_id": "N00001093",
#                  "google_entity_id": "/m/01w74d",
#                  "fec_candidate_id": "S8NY00082",
#                  "url": "https://www.schumer.senate.gov",
#                  "rss_url": "NULL",
#                  "contact_form": "https://www.schumer.senate.gov/contact/email-chuck",
#                  "in_office": true,
#                  "cook_pvi": "NULL",
#                  "dw_nominate": -0.354,
#                  "ideal_point": "NULL",
#                  "seniority": "21",
#                  "next_election": "2022",
#                  "total_votes": 352,
#                  "missed_votes": 0,
#                  "total_present": 1,
#                  "last_updated": "2019-11-08 06:54:49 -0500",
#                  "ocd_id": "ocd-division/country:us/state:ny",
#                  "office": "322 Hart Senate Office Building",
#                  "phone": "202-224-6542",
#                  "fax": "202-228-3027",
#                  "state": "NY",
#                  "senate_class": "3",
#                  "state_rank": "senior",
#                  "lis_id": "S270",
#                  "missed_votes_pct": 0.00,
#                  "votes_with_party_pct": 90.96,
#                  "votes_against_party_pct": 9.04
#                })