class RentalService

  def self.import_file(file_name)
    input = File.read("data/#{file_name}")
    data = JSON.parse(input)

    data['cars'].each { |car| Car.create car }
    data['rentals'].each { |rental| Rental.create(rental) }
  end

  def self.export_file(file_name)
    rentals = { 'rentals': Rental.all.map(&:to_json) }.to_json
    File.write("data/#{file_name}", rentals)
  end
end
