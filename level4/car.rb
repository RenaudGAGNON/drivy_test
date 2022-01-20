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
