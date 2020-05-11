class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :date, presence: true

  def select_driver
    available_list = Driver.select{ |driver| driver.available } # renamed available to available_list for clarity (Suely)
    rand_driver = available_list.sample
    rand_driver.available = false
    rand_driver.save
    self.driver_id = rand_driver.id
  end
end
