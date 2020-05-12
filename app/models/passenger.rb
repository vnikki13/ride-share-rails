class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true, format: { with: /\d{3}.*\d{3}.?\d{4}/ }

  def total_cost
    costs = self.trips.where(passenger_id: self.id).map do |trip|
      trip.cost
    end

    return costs.sum
  end
end
