class RentalService

  def self.import_file(file_name)
    input = File.read("data/#{file_name}")
    data = JSON.parse(input)

    data['cars'].each { |car| Car.create car }
    data['rentals'].each { |rental| Rental.create(rental) }
  end

  def self.export_file(file_name)
    rentals = { 'rentals': rental_to_json }.to_json
    File.write("data/#{file_name}", rentals)
  end

  def self.rental_to_json
    json = Rental.all.map do |rental|
      {'id': rental.id,
      'actions':
          Rental::ACTOR_TYPE.map{ |t| {'who': "#{t[0]}", 'type': "#{t[1]}", 'amount': rental.send(Rental::ACTOR_AMOUNT[t[0]]) }}
      }
    end
    json
  end
end
