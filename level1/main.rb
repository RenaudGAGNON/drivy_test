require 'date'
require 'json'
require './car.rb'
require './rental.rb'
require './rental_service.rb'

RentalService.import_file 'input.json'
RentalService.export_file 'output.json'
