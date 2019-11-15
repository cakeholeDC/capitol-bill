# require_relative '../lib/program/member_methods.rb'
require_relative '../config/environment.rb'

describe "#scan_data_for_both_names" do 
	it "expects 'Charles Schumer' instance when called with 'Chuck Schumer'" do
		expect(scan_data_for_both_names("Chuck Schumer", member_type("senate"), member_class("senate"))[0].full_name).to eq("Charles Schumer")
	end
	
	it "expects 'nancy' to return 'Nancy Pelosi'" do
		expect(scan_data_for_both_names("nancy", member_type("house"), member_class("house"))[0].full_name).to eq("Nancy Pelosi")
	end
end

describe ".slug_match" do
	it "expects the sponsor name to be 'Alexandria Ocasio-Cortez' when called with 'hres666'" do
		expect(Bill.slug_match('hres666').sponsor).to eq("Alexandria Ocasio-Cortez")
	end

	it "expects the sponsor name NOT to be 'Alexandria Ocasio-Cortez' when called with 'sres396'" do
		expect(Bill.slug_match('sres396').sponsor).not_to eq("Alexandria Ocasio-Cortez")
	end

	it "expects the sponsor name to be 'Mr. Chips' when called with 'schoolhouse'" do
		expect(Bill.slug_match('schoolhouse').sponsor).to eq("Mr. Chips")
	end
end

describe 'Senator.most_missed_votes' do
	it "expects 'Cory Booker' when called" do
		expect(Senator.most_missed_votes.full_name).to eq('Cory Booker')
	end
end

describe "HouseMember.most_partisan" do
	it "expects 'Salud Carbajal' when called" do
		expect(HouseMember.most_partisan.full_name).to eq('Salud Carbajal')
	end

	it "expects result NOT to be 'Mr. Chips' when called" do
		expect(HouseMember.most_partisan.full_name).not_to eq("Mr. Chips")
	end
end

describe "Bill.most_cosponsors" do
	it "expects a slug of 'hr4617' when called" do
		expect(Bill.most_cosponsors.slug).to eq("hr4617")
	end

	it "expects the slug to not be 'schoolhouse' when called" do
		expect(Bill.most_cosponsors.slug).not_to eq("schoolhouse")
	end
end