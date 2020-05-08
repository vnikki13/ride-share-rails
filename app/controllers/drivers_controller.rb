class DriversController < ApplicationController

  def index
    @drivers = Driver.all
  end

  def edit
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def update
    @driver = Driver.find(params[:id])
    @driver.update(driver_params)
    redirect_to driver_path(@driver.id)
  end

  def destroy
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      redirect_to root_path
    else
      @driver.destroy
      redirect_to drivers_path
    end
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end

end
