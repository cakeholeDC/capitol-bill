class Vote < ActiveRecord::Base
	belongs_to :house_member
	belongs_to :senator
	belongs_to :bill

	def position_status(lawmaker)
        puts "\n#{lawmaker.full_name}'s position was #{self.vote} on #{self.bill.slug}."
    end
end