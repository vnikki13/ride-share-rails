class DriversController < ApplicationController

  # shows list of drivers
  def index
    @drivers = Driver.all.sort
  end

  # shows individual driver details
  def show
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    end
  end
  
  # creates a form
  def new 
    @driver = Driver.new
  end
    
  # form submit button calls this
  def create
    @driver = Driver.new(driver_params)
    @driver.available = true
    if @driver.save
      redirect_to driver_path(@driver.id)
    else
      render :new
    end
  end
    
  # prepares the driver data to edit it
  def edit
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    end
  end
  
  # updates the driver with the data from the form
  def update
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver.id)
    else
      render :edit
    end
  end
  
  # deletes a driver
  def destroy
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    end
    @driver.destroy
    redirect_to drivers_path
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end

end