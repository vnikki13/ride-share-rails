class PassengersController < ApplicationController

  # shows list of passengers
  def index
    @passengers = Passenger.all.sort
  end

  # shows individual passenger details
  def show
    @passenger = Passenger.find_by(id: params[:id])
    redirect_to passengers_path if @passenger.nil?
  end

  # creates a form
  def new 
    @passenger = Passenger.new
  end
  
  # form submit button calls this
  def create
    @passenger = Passenger.new(
      id: Passenger.maximum(:id).next, # calculate next available id
      name: params[:passenger][:name],
      phone_num: params[:passenger][:phone_num],
    )
    if @passenger.save
      redirect_to passenger_path(@passenger.id)
    else
      render :new
    end
  end
  
  # prepares the passenger data to edit it
  def edit
    @passenger = Passenger.find_by(id: params[:id])
    redirect_to passengers_path if @passenger.nil?
  end

  # updates the passenger with the data from the form
  def update
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
      redirect_to passengers_path
    elsif @passenger.update(
        name: params[:passenger][:name],
        phone_num: params[:passenger][:phone_num],
      )
      redirect_to passenger_path(@passenger.id)
    else
      render :edit
    end
  end

  # deletes a passenger
  def destroy
    @passenger = Passenger.find_by(id: params[:id])
    @passenger.destroy unless @passenger.nil?
    redirect_to passengers_path
  end
  
end
