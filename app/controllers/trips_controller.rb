class TripsController < ApplicationController
  def show
    @trip = Trip.find_by(id: params[:id])
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to trip_path(@trip.id)
    else
      render :new
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])
    redirct_to trip_path if @trip.nil?
  end

  def update
    @trip = Driver.find_by(id: params[:id])
    if @trip.nil?
      redirect_to trip_path
    elsif @trip.update(trip_params)
      redirect_to trip_path(@tirp.id)
    else
      render :edit
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end

end
