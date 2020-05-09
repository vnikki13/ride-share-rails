class TripsController < ApplicationController
  def index
    if params[:passenger_id].nil?
      @trips = Trip.all
    else
      @passenger = Passenger.find_by(id: params[:passenger_id])
      @trips = @passenger.trips
    end

  end

  def show
    @trip = Trip.find_by(id: params[:id])
  end

  def new
    if params[:passenger_id].nil?
      @trip = Trip.new
    else
      passenger = Passenger.find_by(id: params[:passenger_id])
      @passenger_name = passenger.name
      @trip = passenger.trips.new
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.cost = rand(100..500)
    @trip.driver_id = @trip.select_driver
    if @trip.save
      redirect_to trip_path(@trip.id)
    else
      render :new
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])
    redirect_to trip_path if @trip.nil?
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      redirect_to trip_path
    elsif @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
    else
      render :edit
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end

end
