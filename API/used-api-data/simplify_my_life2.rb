require 'net/http'
require 'uri'
require_relative '../votes_importer.rb'
require 'pry'
require_relative './votes.rb'



def passage_vote?(rollcall)
    rollcall["results"]["votes"]["vote"]["question"].include?("Passage")
end

def run_curl2(hash)
    my_array = []
    # binding.pry
    hash.each { |rollcall| 
        if passage_vote?(rollcall)
            uri = URI.parse(rollcall["results"]["votes"]["vote"]["bill"]["api_uri"])
            request = Net::HTTP::Get.new(uri)
            request["X-API-Key"] = API_KEY_CALL_PREFIX

            req_options = {
            use_ssl: uri.scheme == "https",
            }

            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)

            end
        
            my_array << JSON.parse(response.read_body)
        end

        }
    my_array
end

results = run_curl2(data["api_results"])

f = File.new('bills2.json', 'w')
f.write(results)
f.close
# uri = URI.parse("https://api.propublica.org/congress/v1/114/house/votes/missed.json")
# request = Net::HTTP::Get.new(uri)
# request["X-Api-Key"] = "Z2NjClEVvEwMl3quoQKxnMlybpaJe5dRJ39iVYYG"


# response.code
# response.body