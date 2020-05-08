class DriverController < ApplicationController

  def index
    @drivers = Driver.all
  end

end
