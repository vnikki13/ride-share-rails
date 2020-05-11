class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, uniqueness: true, presence: true # added presence to pass the model test (Suely)


  def all_trips
    trips_for_driver = self.trips.where(driver_id: self.id)
  end

  def avg_rating
    trips_for_driver = all_trips
    ratings = Array.new
    trips_for_driver.each do |trip| 
      if !trip.rating.nil?
        ratings << trip.rating 
      end
    end

    if ratings.length == 0
      return nil
    else
      return ratings.sum / ratings.length
    end
  end

  def total_earnings
    earnings = all_trips.map do |trip|
      (trip.cost - 1.65) * 0.8
    end
     return earnings.sum.round(2)
  end
end