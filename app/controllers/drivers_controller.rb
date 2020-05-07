class DriversController < ApplicationController

    # shows list of drivers
    def index
      @drivers = Driver.all.sort
    end
  
    # shows individual driver details
    def show
      @driver = Driver.find_by(id: params[:id])
      redirect_to drivers_path if @driver.nil?
    end
  
    # creates a form
    def new 
      @driver = Driver.new
    end
    
    # form submit button calls this
    def create
      @driver = Driver.new(
        name: params[:driver][:name],
        vin: params[:driver][:vin],
        available: params[:driver][:available]
      )
      if @driver.save
        redirect_to driver_path(@driver.id)
      else
        render :new
      end
    end
    
    # prepares the driver data to edit it
    def edit
      @driver = Driver.find_by(id: params[:id])
      redirect_to drivers_path if @driver.nil?
    end
  
    # updates the driver with the data from the form
    def update
      @driver = Driver.find_by(id: params[:id])
      if @driver.nil?
        redirect_to drivers_path
      elsif @driver.update(
          name: params[:driver][:name],
          vin: params[:driver][:vin],
          available: params[:driver][:available]
        )
        redirect_to driver_path(@driver.id)
      else
        render :edit
      end
    end
  
    # deletes a driver
    def destroy
      @driver = Driver.find_by(id: params[:id])
      @driver.destroy unless @driver.nil?
      redirect_to drivers_path
    end
 
end
