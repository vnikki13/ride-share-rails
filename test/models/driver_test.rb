require "test_helper"

describe Driver do
  let (:new_driver) {
    Driver.new(name: "Kari", vin: "123", available: true)
  }

  describe "basic tests" do
    it "can be instantiated" do
      # Assert
      expect(new_driver.valid?).must_equal true
    end

    it "will have the required fields" do
      # Arrange
      new_driver.save
      driver = Driver.first
      [:name, :vin, :available].each do |field|
        # Assert
        expect(driver).must_respond_to field
      end
    end
  end

  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_driver.save
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3)
      # Assert
      expect(new_driver.trips.count).must_equal 2
      new_driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_driver.name = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :name
      expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a VIN number" do
      # Arrange
      new_driver.vin = nil
      new_driver.save

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :vin
      expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
    end

    it "must have a unique VIN number" do
      # Arrange
      new_driver.save
      conflicting_driver = Driver.new(name: "Cathy", vin: "123", available: true)

      # Assert
      expect(conflicting_driver.valid?).must_equal false
      expect(conflicting_driver.errors.messages).must_include :vin
      expect(conflicting_driver.errors.messages[:vin]).must_equal ["has already been taken"]
    end

  end

  # Tests for methods you create should go here
  describe "custom methods" do
    describe "average rating" do
      it "calculates the average rating" do
        # Arrange
        new_driver.save
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        new_passenger.save
        # Assert - No trips
        expect(new_driver.avg_rating).must_be_nil
        # Act and Assert - 1 trip
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5)
        trip_1.save
        new_driver.reload
        expect(new_driver.avg_rating).must_equal 5
        # Act and Assert - 2 trips
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3)
        new_driver.reload
        expect(new_driver.avg_rating).must_equal 4
      end
    end
    describe "total earnings" do
      it "calculates the total earnings" do
        # Arrange
        new_driver.save
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        new_passenger.save
        # Assert - No trips
        expect(new_driver.total_earnings).must_equal 0
        # Act and Assert - 1 trip
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, cost: 200)
        trip_1.save
        earnings = (200 - 1.65) * 0.8
        new_driver.reload
        expect(new_driver.total_earnings).must_be_close_to earnings, 0.01
        # Act and Assert - 2 trips
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, cost: 100)
        earnings += (100 - 1.65) * 0.8
        new_driver.reload
        expect(new_driver.total_earnings).must_be_close_to earnings, 0.01
      end
    end
  end
end
