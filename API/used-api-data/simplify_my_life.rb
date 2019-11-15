require 'net/http'
require 'uri'
require_relative '../votes_importer.rb'
require 'pry'


def run_curl(hash)
    my_array = []
    # binding.pry
    hash.each { |rollcall| 
        uri = URI.parse(rollcall[:vote_uri])
        request = Net::HTTP::Get.new(uri)
        request["X-API-Key"] = API_KEY_CALL_PREFIX

        req_options = {
          use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)

        end
        
        my_array << JSON.parse(response.read_body)
    }
    my_array
end

variable = run_curl(VOTES)

f = File.new('votes.json', 'w')
f.write(variable)
f.close
# uri = URI.parse("https://api.propublica.org/congress/v1/114/house/votes/missed.json")
# request = Net::HTTP::Get.new(uri)
# request["X-Api-Key"] = "Z2NjClEVvEwMl3quoQKxnMlybpaJe5dRJ39iVYYG"


# response.code
# response.body