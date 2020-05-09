class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true, format: {with: /\d{3}.*\d{3}.?\d{4}/ }
end
