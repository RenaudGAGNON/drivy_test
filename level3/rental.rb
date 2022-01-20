require './price_rules_concern.rb'
require './commission_concern.rb'

class Rental
  prepend PriceRulesConcern
  include CommissionConcern

  DEFAULT_DATE_FORMAT = '%Y-%m-%d'.freeze

  @@rentals = []
  attr_reader :id
  attr_reader :car
  attr_reader :start_date
  attr_reader :end_date
  attr_reader :distance

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

  def to_json
    {
      'id': id,
      'price': price,
      'commission':
        {
          'insurance_fee': insurance_fee,
          'assistance_fee': assistance_fee,
          'drivy_fee': internal_commision
        }
    }
  end

private
  def price_per_km
    @car.price_per_km * @distance
  end

  def price_per_day
    @car.price_per_day * ((@end_date - @start_date) + 1)
  end
end
