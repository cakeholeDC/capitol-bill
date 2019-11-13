require 'pry'
require 'date'
require_relative './useful-json-files/votes.rb'
# NOTES 
#
# Raw API JSON data can be found in ./raw/[branch].json
#
# Importer will fail if any values are "null" or nil
# 
# Update these values to '"NULL"' (as string)


api_data = data()
 

VOTES = api_data["api_results"]
