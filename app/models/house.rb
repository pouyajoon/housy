class House < ActiveRecord::Base
  def rent_formatted
    "%0.02f €" % self.rent
  end
  def apartment_costs_formatted
    "%0.02f €" % self.apartment_costs
  end
  def total_rent
    "%0.02f €" % (self.rent + self.apartment_costs)
  end
end
