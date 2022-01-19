require 'date'
require 'json'

DEFAULT_DATE_FORMAT = '%Y-%m-%d'

class Car
  @@cars = []
  attr_reader :id
  attr_reader :price_per_km
  attr_reader :price_per_day

  def initialize(params = {})
    @id = params['id']
    @price_per_km = params['price_per_km']
    @price_per_day = params['price_per_day']
  end

  def self.create(params = {})
    @@cars << self.new(params)
  end

  def self.find(id)
    @@cars.find{ |car| car.id == id }
  end
end

class Rental
  @@rentals = []
  attr_reader :id
  attr_reader :car

  def initialize(params = {})
    @id = params['id']
    @car_id = params['car_id']
    @start_date = Date.strptime params['start_date'], DEFAULT_DATE_FORMAT
    @end_date = Date.strptime params['end_date'], DEFAULT_DATE_FORMAT
    @distance = params['distance']
    @car = Car.find @car_id
  end

  def self.create(params = {})
    @@rentals << self.new(params)
  end

  def self.all
    @@rentals
  end
end


input = File.read('data/input.json')
data = JSON.parse(input)

data['cars'].each { |car| Car.create car }
data['rentals'].each { |rental| Rental.create(rental) }

Rental.all.each { |rental| puts "#{rental.id} - #{rental.car.id}" }
