require 'pry'
require 'date'
require_relative './used-api-data/votes.rb'
# NOTES 
#
# Importer will fail if any values are "null" or nil
# 
# Update these values to '"NULL"' (as string)


api_data = data()
 

VOTES = api_data["api_results"]
