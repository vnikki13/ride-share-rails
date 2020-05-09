class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :date, presence: true

  def select_driver
    available = Driver.select{ |driver| driver.available }
    rand_driver = available.sample
    rand_driver.available = false
    rand_driver.save
    self.driver_id = rand_driver.id
  end
end
