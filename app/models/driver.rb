class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, uniqueness: true


  def all_trips
    trips_for_driver = self.trips.where(driver_id: self.id)
  end

  def avg_rating
    trips_for_driver = all_trips
    ratings = Array.new
    trips_for_driver.each { |trip| ratings << trip.rating }
    if ratings.length == 0
      return 'No ratings'
    else
      return ratings.sum / ratings.length
    end
  end

  def total_earnings
    trips_for_driver = all_trips
    earnings = Array.new
    trips_for_driver.each do |trip|
      earnings << (trip.cost - 1.65) * 0.8
    end
     return earnings.sum.round(2)
  end
end
