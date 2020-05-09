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
  
    # shows individual passenger details
    def show
      @passenger = Passenger.find_by(id: params[:id])
      if @passenger.nil?
        head :not_found
        return
      end
    end
  end
  
    # creates a form
    def new 
      @passenger = Passenger.new
    end
    
    # form submit button calls this
    def create
      @passenger = Passenger.new(
        id: Passenger.maximum(:id) ? Passenger.maximum(:id).next : 1,
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
      if @passenger.nil?
        head :not_found
        return
      end
    end
  
    # updates the passenger with the data from the form
    def update
      @passenger = Passenger.find_by(id: params[:id])
      if @passenger.nil?
        head :not_found
        return
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
      if @passenger.nil?
        head :not_found
        return
      end
      @passenger.destroy
      redirect_to passengers_path
    end
  
end
