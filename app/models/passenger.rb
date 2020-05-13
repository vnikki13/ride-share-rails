class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true, format: { with: /\d{3}.*\d{3}.?\d{4}/ }

  def total_cost
    cost = 0
    self.trips.each do |trip|
      cost += trip.cost
    end

    return cost
  end
end
