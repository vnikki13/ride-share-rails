require "test_helper"

describe Trip do

  let (:new_driver) {
    Driver.new(name: "Kari", vin: "123", available: true)
  }

  let (:new_passenger) {
    Passenger.new(name: "Kari", phone_num: "111-111-1211")
  }

  let (:new_trip) {
    Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
  }
  
  describe "basic tests" do
    it "can be instantiated" do
      # Arrange
      new_driver.save
      new_passenger.save
      new_trip.save
      
      # Assert
      expect(new_trip.valid?).must_equal true
    end

    it "will have the required fields" do
      # Arrange
      new_driver.save
      new_passenger.save
      new_trip.save

      trip = Trip.first
      [:driver_id, :passenger_id, :date, :rating, :cost].each do |field|
        # Assert
        expect(trip).must_respond_to field
      end
    end
  end

  describe "relationships" do
    it "trip belongs to driver and passenger" do
      # Arrange
      new_driver.save
      new_passenger.save
      new_trip.save

      # Assert
      expect(new_trip.passenger).must_be_instance_of Passenger
      expect(new_trip.passenger.id).must_equal new_passenger.id
      expect(new_trip.driver).must_be_instance_of Driver
      expect(new_trip.driver.id).must_equal new_driver.id
    end
  end

  describe "validations" do
    it "must have a date" do
      # Arrange
      new_trip.date = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :date
      expect(new_trip.errors.messages[:date]).must_equal ["can't be blank"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    it "selects an available driver for the trip" do
      # Arrange
      new_driver.save
      new_passenger.save
      new_trip.driver_id = nil

      # Act
      new_trip.select_driver

      # Assert
      expect(new_trip.driver_id).must_equal new_driver.id
      expect(new_driver.available).must_equal false
    end
  end
end
