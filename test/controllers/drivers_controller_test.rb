require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.
  let (:temp_driver) {
    Driver.create name: "sample driver",
                  vin: "12RCT6739277CDR",
                  available: true
  }

  describe "index" do

    it "responds with success when there are no drivers saved" do

      # Ensure that there are zero drivers saved
      driver_count = Driver.all.size
      expect(driver_count).must_equal 0
      # Act
      get drivers_path
      
      # Assert
      must_respond_with :success
    end
        
    it "responds with success when there are many drivers saved" do
      # Arrange
      temp_driver.save

      # Ensure that there is at least one Driver saved
      driver_count = Driver.all.size
      expect(driver_count).must_equal 1

      # Act
      get drivers_path
      
      # Assert
      must_respond_with :success
    end

  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      # Ensure that there is a driver saved
      # Act
      get driver_path(temp_driver.id)
      # Assert
      must_respond_with :success
    end

    it "responds with 404 with an invalid driver id" do
      # Ensure that there is an id that points to no driver

      # Act
      get driver_path(-1)
      # Assert
      must_respond_with :missing
    end
  end

  describe "new" do
    it "responds with success" do
      # Act
      get new_driver_path
      
      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange
      driver_hash = {
        driver: {
          name: "new driver",
          vin: "12RCT6739277CDR",
          available: true,
        },
      }
      
      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1
      
      # Assert
      # Find the newly created Driver and check that all its attributes
      # match what was given in the form data
      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.available).must_equal driver_hash[:driver][:available]

      # Assert
      # Check that the controller redirected the user
      must_respond_with :redirect

      # Assert
      # Check that the controller redirected the user
      must_redirect_to driver_path(new_driver.id)

    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      skip
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects

    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange
      # temp_driver is an existing driver defined above

      # Act
      get edit_driver_path(temp_driver.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # -1 is an invalid id that points to no driver

      # Act
      get edit_driver_path(-1)
      # Assert
      must_respond_with :missing

    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      existing_driver = Driver.create(name: "Old driver",
                                      vin: "12345ABCD678",
                                      available: true
      )
      
      # Set up the form data
      driver_hash = {
        driver: {
          name: "new driver",
          vin: "12RCT6739277CDR",
          available: true,
        },
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(existing_driver.id), params: driver_hash
      }.must_differ "Driver.count", 0
 
      # Assert
      # Find the updated Driver and check that all its attributes
      # match what was given in the form data
      updated_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(updated_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(updated_driver.available).must_equal driver_hash[:driver][:available]

      # Assert
      # Check that the controller redirected the user
      must_redirect_to driver_path(updated_driver.id)

    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Arrange
      # -1 is an invalid id that points to no driver
      # Set up the form data
      driver_hash = {
        driver: {
          name: "new driver",
          vin: "12RCT6739277CDR",
          available: true,
        },
      }

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(-1), params: driver_hash
      }.must_differ "Driver.count", 0
 
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :missing

    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      skip
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects

    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do

      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      existing_driver = Driver.create(name: "Old driver",
                                      vin: "12345ABCD678",
                                      available: true
      )
      
      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count
      expect {
        delete driver_path(existing_driver.id)
      }.must_differ "Driver.count", -1
 
      # Assert
      # Check that the controller redirected the user
      must_redirect_to drivers_path
      
    end

    it "does not change the db when the driver does not exist, then responds with 404 " do
      # Arrange
      # -1 is an invalid id that points to no driver
            
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        delete driver_path(-1)
      }.must_differ "Driver.count", 0
 
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :missing

    end

  end

end
