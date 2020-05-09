require "test_helper"

describe PassengersController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.
  let (:temp_passenger) {
    Passenger.create name: "sample passenger",
                  phone_num: "1-800-555-1234"
  }

  describe "index" do

    it "responds with success when there are no passengers saved" do

      # Ensure that there are zero passengers saved
      passenger_count = Passenger.all.size
      expect(passenger_count).must_equal 0
      # Act
      get passengers_path
      
      # Assert
      must_respond_with :success
    end
        
    it "responds with success when there are many passengers saved" do
      # Arrange
      temp_passenger.save

      # Ensure that there is at least one Passenger saved
      passenger_count = Passenger.all.size
      expect(passenger_count).must_equal 1

      # Act
      get passengers_path
      
      # Assert
      must_respond_with :success
    end

  end

  describe "show" do
    it "responds with success when showing an existing valid passenger" do
      # Ensure that there is a passenger saved
      # Act
      get passenger_path(temp_passenger.id)
      # Assert
      must_respond_with :success
    end

    it "responds with 404 with an invalid passenger id" do
      # Ensure that there is an id that points to no passenger

      # Act
      get passenger_path(-1)
      # Assert
      must_respond_with :missing
    end
  end

  describe "new" do
    it "responds with success" do
      # Act
      get new_passenger_path
      
      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      # Arrange
      passenger_hash = {
        passenger: {
          name: "new passenger",
          phone_num: "1-888-555-4321"
        },
      }
      
      # Act-Assert
      # Ensure that there is a change of 1 in Passenger.count
      expect {
        post passengers_path, params: passenger_hash
      }.must_change "Passenger.count", 1
      
      # Assert
      # Find the newly created Passenger and check that all its attributes
      # match what was given in the form data
      new_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])
      expect(new_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]

      # Assert
      # Check that the controller redirected the user
      must_respond_with :redirect

      # Assert
      # Check that the controller redirected the user
      must_redirect_to passenger_path(new_passenger.id)

    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      skip
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Passenger validations

      # Act-Assert
      # Ensure that there is no change in Passenger.count

      # Assert
      # Check that the controller redirects

    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid passenger" do
      # Arrange
      # temp_passenger is an existing passenger defined above

      # Act
      get edit_passenger_path(temp_passenger.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      # Arrange
      # -1 is an invalid id that points to no passenger

      # Act
      get edit_passenger_path(-1)
      # Assert
      must_respond_with :missing

    end
  end

  describe "update" do
    it "can update an existing passenger with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing passenger saved
      # Assign the existing passenger's id to a local variable
      existing_passenger = Passenger.create(name: "Old passenger",
                                      phone_num: "1-888-555-6789"
      )
      
      # Set up the form data
      passenger_hash = {
        passenger: {
          name: "new passenger",
          phone_num: "1-888-555-9876"
        },
      }
      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        patch passenger_path(existing_passenger.id), params: passenger_hash
      }.must_differ "Passenger.count", 0
 
      # Assert
      # Find the updated Passenger and check that all its attributes
      # match what was given in the form data
      updated_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])
      expect(updated_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]

      # Assert
      # Check that the controller redirected the user
      must_redirect_to passenger_path(updated_passenger.id)

    end

    it "does not update any passenger if given an invalid id, and responds with a 404" do
      # Arrange
      # -1 is an invalid id that points to no passenger
      # Set up the form data
      passenger_hash = {
        passenger: {
          name: "new passenger",
          phone_num: "1-888-555-9876"
        },
      }

      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        patch passenger_path(-1), params: passenger_hash
      }.must_differ "Passenger.count", 0
 
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :missing

    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      skip
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing passenger saved
      # Assign the existing passenger's id to a local variable
      # Set up the form data so that it violates Passenger validations

      # Act-Assert
      # Ensure that there is no change in Passenger.count

      # Assert
      # Check that the controller redirects

    end
  end

  describe "destroy" do
    it "destroys the passenger instance in db when passenger exists, then redirects" do

      # Arrange
      # Ensure there is an existing passenger saved
      # Assign the existing passenger's id to a local variable
      existing_passenger = Passenger.create(name: "Old passenger",
                                      phone_num: "1-888-555-5555"
      )
      
      # Act-Assert
      # Ensure that there is a change of -1 in Passenger.count
      expect {
        delete passenger_path(existing_passenger.id)
      }.must_differ "Passenger.count", -1
 
      # Assert
      # Check that the controller redirected the user
      must_redirect_to passengers_path
      
    end

    it "does not change the db when the passenger does not exist, then responds with 404 " do
      # Arrange
      # -1 is an invalid id that points to no passenger
            
      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect {
        delete passenger_path(-1)
      }.must_differ "Passenger.count", 0
 
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :missing

    end

  end

end
