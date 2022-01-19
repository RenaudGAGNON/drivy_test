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

  def self.find(id)
    @@cars.find{ |car| car.id == id }
  end

  def self.create(params = {})
    car = self.new(params)
    @@cars << car
    car
  end

  def self.all
    @@cars
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
    rental = self.new(params)
    @@rentals << rental
    rental
  end

  def self.all
    @@rentals
  end

  def price
    (price_per_day + price_per_km).to_i
  end

private
  def price_per_km
    @car.price_per_km * @distance
  end

  def price_per_day
    @car.price_per_day * ((@end_date - @start_date) + 1)
  end
end

input = File.read('data/input.json')
data = JSON.parse(input)

data['cars'].each { |car| Car.create car }
data['rentals'].each { |rental| Rental.create(rental) }

Rental.all.each { |rental| puts "#{rental.id} - #{rental.price}" }
