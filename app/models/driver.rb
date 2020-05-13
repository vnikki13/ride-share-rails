class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, uniqueness: true, presence: true

  def avg_rating
    trips_for_driver = self.trips
    ratings = 0
    count = 0
    trips_for_driver.each do |trip| 
      if !trip.rating.nil?
        ratings += trip.rating
        count += 1
      end
    end
    if count == 0
      return nil
    else
      return ratings / count
    end
  end

  def total_earnings
    earnings = self.trips.map do |trip|
      (trip.cost - 1.65) * 0.8
    end
     return earnings.sum.round(2)
  end
end