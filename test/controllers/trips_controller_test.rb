require "test_helper"

describe TripsController do

  let (:temp_driver) {
    Driver.create name: "sample driver",
                  vin: "12RCT6739277CDR",
                  available: true
  }

  let (:temp_passenger) {
    Passenger.create name: "sample passenger",
                  phone_num: "800-555-1234"
  }

  let (:temp_trip) {
    Trip.create passenger_id: temp_passenger.id,
                driver_id: temp_driver.id,
                date: "2020-05-09".to_date,
                rating: 5
  }

  describe "index" do

    it "responds with success when there are no trips saved" do
      # Arrange
      temp_driver.save
      temp_passenger.save

      # Ensure that there are zero trips saved
      trip_count = temp_passenger.trips.size
      expect(trip_count).must_equal 0

      # Act
      get passenger_trips_path(temp_passenger)
      
      # Assert
      must_respond_with :success
    end
        
    it "responds with success when there are many trips saved" do
      # Arrange
      temp_driver.save
      temp_passenger.save
      temp_trip.save

      # Ensure that there is at least one Driver saved
      trip_count = temp_passenger.trips.size
      expect(trip_count).must_equal 1

      # Act
      get passenger_trips_path(temp_passenger)
      
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid trip" do
      # Ensure that there is a trip saved
      # Act
      get trip_path(temp_trip.id)
      # Assert
      must_respond_with :success
    end

    it "responds with 404 with an invalid trip id" do
      # Ensure that there is an id that points to no trip

      # Act
      get trip_path(-1)
      # Assert
      must_respond_with :missing
    end
  end

  describe "new" do
    it "responds with success" do
      # Act
      get new_trip_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "new by passenger" do
    it "responds with success with a valid passenger" do
      # Act
      get new_passenger_trip_path(temp_passenger.id)
      
      # Assert
      must_respond_with :success
    end

    it "responds with success with a valid passenger" do
      # Act
      get new_passenger_trip_path(-1)
      
      # Assert
      must_respond_with :missing
    end

  end
  
  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      temp_driver.save
      temp_passenger.save

      trip_hash = {
        trip: {
          passenger_id: temp_passenger.id,
          driver_id: temp_driver.id,
          date: "2020-05-08".to_date,
          rating: 4
        },
      }
      
      # Act-Assert
      # Ensure that there is a change of 1 in Trip.count
      expect {
        post trips_path, params: trip_hash
      }.must_change "Trip.count", 1
      
      # Assert
      # Find the newly created Trip and check that all its attributes
      # match what was given in the form data
      new_trip = Trip.find_by(passenger_id: trip_hash[:trip][:passenger_id])
      expect(new_trip.driver_id).must_equal trip_hash[:trip][:driver_id]
      expect(new_trip.date).must_equal trip_hash[:trip][:date]
      expect(new_trip.rating).must_equal trip_hash[:trip][:rating]
      
      # Assert
      # Check that the controller redirected the user
      must_respond_with :redirect

      # Assert
      # Check that the controller redirected the user
      must_redirect_to trip_path(new_trip.id)
    end

    it "does not create a trip if the form data violates Trip validations, date is empty" do
      # Arrange
      temp_driver.save
      temp_passenger.save

      # Set up the form data so that it violates Trip validations
      trip_hash = {
        trip: {
          passenger_id: temp_passenger.id,
          driver_id: temp_driver.id,
          date: nil,
          rating: 4
        },
      }
      
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        post trips_path, params: trip_hash
      }.must_differ "Trip.count", 0
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid trip" do
      # Arrange
      # temp_trip is an existing trip
      temp_driver.save
      temp_passenger.save
      temp_trip.save
      
      # Act
      get edit_trip_path(temp_trip.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      # Arrange
      # -1 is an invalid id that points to no trip

      # Act
      get edit_trip_path(-1)
      # Assert
      must_respond_with :missing

    end
  end

  describe "update" do
    it "can update a trip with valid information accurately, and redirect" do
      # Arrange
      temp_driver.save
      temp_passenger.save
      temp_trip.save

      trip_hash = {
        trip: {
          date: "2020-05-08".to_date,
          rating: 4
        },
      }
      
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        patch trip_path(temp_trip.id), params: trip_hash
      }.must_differ "Trip.count", 0
      
      # Assert
      # Find the newly updated Trip and check that all its attributes
      # match what was given in the form data
      updated_trip = Trip.find_by(id: temp_trip.id)
      expect(updated_trip.date).must_equal trip_hash[:trip][:date]
      expect(updated_trip.rating).must_equal trip_hash[:trip][:rating]
      
      # Assert
      # Check that the controller redirected the user
      must_respond_with :redirect

      # Assert
      # Check that the controller redirected the user
      must_redirect_to trip_path(updated_trip.id)
    end

    it "does not create a trip if the form data violates Trip validations, date is empty" do
      # Arrange
      temp_driver.save
      temp_passenger.save
      temp_trip.save

      trip_hash = {
        trip: {
          date: nil,
          rating: 4
        },
      }

      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        patch trip_path(temp_trip.id), params: trip_hash
      }.must_differ "Trip.count", 0

      # Assert
      # Find the newly updated Trip and check that all its attributes
      # match what was given in the form data
      updated_trip = Trip.find_by(id: temp_trip.id)
      expect(updated_trip.date).wont_equal trip_hash[:trip][:date]
      expect(updated_trip.rating).wont_equal trip_hash[:trip][:rating]
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do

      # Arrange
      temp_driver.save
      temp_passenger.save
      temp_trip.save
      
      # Act-Assert
      # Ensure that there is a change of -1 in Trip.count
      expect {
        delete trip_path(temp_trip.id)
      }.must_differ "Trip.count", -1
 
      # Assert
      # Check that the controller redirected the user
      must_redirect_to trips_path
      
    end

    it "does not change the db when the trip does not exist, then responds with 404 " do
      # Arrange
      # -1 is an invalid id that points to no trip
            
      # Act-Assert
      # Ensure that there is no change in Trip.count
      expect {
        delete trip_path(-1)
      }.must_differ "Trip.count", 0
 
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :missing
    end
  end
end
