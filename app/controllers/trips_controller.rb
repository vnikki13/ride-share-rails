class TripsController < ApplicationController
  def index
    if params[:passenger_id]
      passenger = Passenger.find_by(id: params[:passenger_id])
      @trips = passenger.trips
    elsif params[:driver_id]
      driver = Driver.find_by(id: params[:driver_id])
      @trips = driver.trips
    else
      @trips = Trip.all
    end
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    end
  end

  def new
    if params[:passenger_id]
      passenger = Passenger.find_by(id: params[:passenger_id])
      if passenger.nil?
        head :not_found
        return
      end 
      @trip = passenger.trips.new
    else
      @trip = Trip.new
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.cost = rand(100..500)
    @trip.select_driver
    if @trip.save
      redirect_to trip_path(@trip.id)
    else
      render :new
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      render :edit
    elsif @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
    end
  end

  def destroy
    trip = Trip.find_by(id: params[:id])
    if trip.nil?  
      head :not_found
      return
    end

    trip.destroy 
    redirect_to trips_path
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end

end
