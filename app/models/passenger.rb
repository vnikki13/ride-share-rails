class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true, format: {with: /\d{3}.*\d{3}.?\d{4}/ }

  def all_trips
    trips_for_passenger = self.trips.where(passenger_id: self.id)
  end

  def total_cost
    costs = all_trips.map do |trip|
      trip.cost
    end

    return costs
  end
end
