class TripController < ApplicationController

  def index
    @trips = Trip.all
  end
end
